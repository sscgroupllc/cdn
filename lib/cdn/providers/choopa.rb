module CDN
  class Choopa
    def self.generate_token(path, options = {})
      self.new.generate_token(path, options)
    end

    def self.generate_url(options = {})
      ((options[:protocol] == :https) ? URI::HTTPS : URI::HTTP).build(
        host: options[:domain],
        path: options[:path],
        query: options[:token])
    end

    def generate_token(path, options = {})
      return '' if options[:token] && options[:token][:cdn_type].to_s == 'small'

      options[:start] ||= 0
      options[:expires_in] ||= 600

      expires_at = (options[:expires_in].is_a?(Fixnum)) ? Time.now.to_i + options[:expires_in] : options[:expires_in].to_i
      expires_at_hex = expires_at.to_s(16)
      hash = Digest::MD5.hexdigest(File.join(path, CDN.configuration.http_large_secret, expires_at_hex))

      "e=#{expires_at_hex}&h=#{hash}&start=#{options[:start]}"
    end
  end
end
