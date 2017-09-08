require "digest/md5"

module CDN
  class Beluga
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
      return "" if options[:token] && options[:token][:cdn_type].to_s == "small"
      options = self.normalize_options(options)
      hash_string = "#{path}?" + params_string(options)
      params_string(options) + "&token=" + hash_string(hash_string, CDN.configuration.http_large_secret)
    end

    protected

    def hash_string(string, secret)
      Digest::MD5.hexdigest(sprintf("%s&pass=%s", string, secret))
    end

    def params_string(options)
      options.collect { |k,v| "#{k}=#{v}" }.join("&")
    end

    def normalize_options(options = {})
      params = {}
      params[:expires] = options.fetch(:expires_in, Time.now + 600).to_i
      params[:expires] += ntp_drift_seconds
      params
    end

    def ntp_drift_seconds
      (CDN.configuration.ntp_drift_seconds || 300).to_i
    end
  end
end
