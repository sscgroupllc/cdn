module CDN
  class Swiftwill
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
      start = options[:start] || 0
      options = self.normalize_options(options)
      query_string = "#{path}?" + params_string(options)
      options.delete(:clientip)
        params_string(options) + '&hash=0' + hash_string(query_string, CDN.configuration.http_large_secret) + "&start=#{start}"
    end

  protected

    def hash_string(string, secret)
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha1"), secret.to_s, string.to_s)[0..19]
    end

    def params_string(options)
      options.to_query
    end

    def normalize_options(options)
      params = {}
      options[:expires_in] ||= 600
      options[:expires_in] += ntp_drift_seconds
      params[:clientip] = options[:allow_ip] if options[:allow_ip]
      params[:nvb] = (Time.now - ntp_drift_seconds).utc.strftime("%Y%m%d%H%M%S")
      params[:nva] = ((options[:expires_in].is_a?(Fixnum)) ? Time.now.utc + options[:expires_in] : options[:expires_in]).utc.strftime("%Y%m%d%H%M%S")
      params
    end

    def ntp_drift_seconds
      (CDN.configuration.ntp_drift_seconds || 300).to_i
    end
  end
end
