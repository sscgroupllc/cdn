module CDN
  class Cloudfront
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
      url = if options[:token] && options[:token][:cdn_type].to_s == 'small'
        AwsCfSigner.new(CDN.configuration.aws_pem_file).sign(
          "http://#{options[:domain]}#{path}",
          { ending: Time.now.utc + 1.year })
      else
        AwsCfSigner.new(CDN.configuration.aws_pem_file).sign(
          "http://#{options[:domain]}#{path}",
          self.normalize_options(options))
      end

      url.split('?').last
    end

  protected

    def normalize_options(options)
      params = {}
      params[:ip_range] = options[:allow_ip] if options[:allow_ip]
      params[:ending] = (options[:expires_in].is_a?(Fixnum)) ? Time.now.utc + options[:expires_in] : Time.now.utc + 1.hour
      params
    end
  end
end
