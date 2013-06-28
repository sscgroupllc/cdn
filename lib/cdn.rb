require 'openssl'
require 'uri'
require 'cgi'
require 'aws_cf_signer'
require 'active_support/core_ext'
require 'active_support/inflector'

require 'cdn/configuration'
require 'cdn/providers/choopa'
require 'cdn/providers/swiftwill'
require 'cdn/providers/cloudfront'

# CDN helper methods.
#
# The CDN can be configured like so:
#
#   CDN.configure do |config|
#     config.enabled = true
#     config.provider = "MyProvider"
#     config.domain = "mydomain.com"
#     config.http_large_secret = "secret"
#     config.http_small_secret = "secret"
#   end
#
# The CDN module uses provider classes for 
# the actual implmentation of each service.
#
# A provider class needs to implement two methods
# for compliance.
#
#   generate_token(file_name, options)
#   generate_url(options)
#
# Each of the methods should return a string
#
# To use the helper, include the module.
#
#   class ApplicationController
#     include CDN
#   end
#
# And then simply call the helper.
#
#   cdn_large_url("/path/to/my/file")
#
# It can also be called with options.
#
#   cdn_large_url("/path/to/my/file",
#                 :protocol => "https",
#                 :domain => "mydomain.com",
#                 :token => { :expires_in => 1.day })

module CDN
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    config = configuration
    yield(config)
  end

  def self.cdn_provider
    "CDN::#{self.configuration.provider}".constantize
  end

  # Generates a CDN url for the path and options given.
  # Uses the set CDN provider given in the configuration.
  #
  # path - Relative path for file.
  # options - Hash of options given to the generator.
  #           Also takes a :token to customize the token generator.
  #
  # Returns a url.

  def cdn_url(path, options = {})
    return path unless CDN.configuration.enabled

    options[:token] ||= {}
    options[:domain] ||= CDN.configuration.domain
    path = CDN.configuration.path_processor.call(path) if CDN.configuration.path_processor

    url = CDN.cdn_provider.generate_url(
      protocol: options[:protocol] || :http,
      domain: options[:domain],
      path: URI.parse(path).path,
      token: CDN.cdn_provider.generate_token(path, options))

    # Preserving any existing query params.
    if query = URI.parse(path).query
      query = CGI.parse(query)
      query = query.merge(CGI.parse(url.query.to_s))
      url.query = query.collect { |k,v| (v.empty?) ? k : "#{k}=#{v[0]}" }.join("&")
    end

    url.to_s
  end

  # Alias for cdn_url with :cdn_type set to large.
  #
  # Returns a url.

  def cdn_large_url(path, options = {})
    cdn_url(path, { :token => { :cdn_type => :large }}.merge(options))
  end

  # Alias for cdn_url with :cdn_type set to small.
  #
  # Returns a url.

  def cdn_small_url(path, options = {})
    options[:domain] ||= CDN.configuration.small_domain
    options[:domain] ||= CDN.configuration.domain
    cdn_url(path, { token: { cdn_type: :small }}.merge(options))
  end
end
