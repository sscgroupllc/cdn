module CDN
  class Configuration
    attr_accessor :enabled
    attr_accessor :provider
    attr_accessor :domain
    attr_accessor :port
    attr_accessor :small_domain
    attr_accessor :http_large_secret
    attr_accessor :http_small_secret
    attr_accessor :protocol
    attr_accessor :path_processor
    attr_accessor :aws_pem_file
    attr_accessor :ntp_drift_seconds
  end
end
