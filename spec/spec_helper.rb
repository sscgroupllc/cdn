require "cdn"
require "timecop"

module CDN
  class TestProvider
    def self.generate_token(file_name, options = {})
      "testtoken"
    end

    def self.generate_url(options = {})
      ((options[:protocol] == :https) ? URI::HTTPS : URI::HTTP).build(
        :host => options[:domain],
        :port => options[:port],
        :path => options[:path],
        :query => options[:token],
      )
    end
  end
end

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end
