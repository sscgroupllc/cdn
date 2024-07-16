module CDN
  class Reflected
    def self.generate_token(path, options = {})
      self.new.generate_token(path, options)
    end

    def self.generate_url(options = {})
      ((options[:protocol] == :https) ? URI::HTTPS : URI::HTTP).build(
        host: options[:domain],
        port: options[:port],
        path: options[:path],
        query: options[:token])
    end

    def generate_token(path, options = {})
      return '' if options[:token] && options[:token][:cdn_type].to_s == 'small'
      query = "validfrom=#{Time.now.to_i}&validto=#{(Time.now.utc + options[:expires_in]).utc.to_i}"
      uri = "#{path}?#{query}"
      hash = CGI.escape(Base64.strict_encode64(OpenSSL::HMAC.digest('sha1', CDN.configuration.http_large_secret, uri)))

      "#{query}&hash=#{hash}"
    end
  end
end
