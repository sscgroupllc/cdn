module CDN
  class Development
    def self.generate_token(file_name, options = {})
      "development"
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
