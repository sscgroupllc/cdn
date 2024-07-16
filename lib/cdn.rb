require "openssl"
require "uri"
require "cgi"
require "aws_cf_signer"

require "cdn/configuration"
require "cdn/providers/beluga"
require "cdn/providers/choopa"
require "cdn/providers/development"
require "cdn/providers/swiftwill"
require "cdn/providers/cloudfront"
require "cdn/providers/reflected"

# CDN helper methods.
#
module CDN
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    config = configuration
    yield(config)
  end

  def self.cdn_provider
    Module.const_get("CDN::#{self.configuration.provider}")
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
    options[:port] ||= CDN.configuration.port

    path = CDN.configuration.path_processor.call(path) if CDN.configuration.path_processor

    url = CDN.cdn_provider.generate_url(
      protocol: options[:protocol] || CDN.configuration.protocol || :http,
      domain: options[:domain],
      port: options[:port],
      path: URI.parse(path).path,
      token: CDN.cdn_provider.generate_token(path, options),
    )

    # Preserving any existing query params.
    if query = URI.parse(path).query
      query = CGI.parse(query)
      query = query.merge(CGI.parse(url.query.to_s))
      url.query = query.collect { |k, v| (v.empty?) ? k : "#{k}=#{v[0]}" }.join("&")
    end

    url.to_s
  end

  # Alias for cdn_url with :cdn_type set to large.
  #
  # Returns a url.

  def cdn_large_url(path, options = {})
    cdn_url(path, { :token => { :cdn_type => :large } }.merge(options))
  end

  # Alias for cdn_url with :cdn_type set to small.
  #
  # Returns a url.

  def cdn_small_url(path, options = {})
    options[:domain] ||= CDN.configuration.small_domain
    options[:domain] ||= CDN.configuration.domain
    cdn_url(path, { token: { cdn_type: :small } }.merge(options))
  end
end
