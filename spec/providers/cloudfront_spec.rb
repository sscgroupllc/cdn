require "spec_helper"

describe CDN::Cloudfront do
  let(:time_format) { "%Y%m%d%H%M%S" }

  before do
    CDN.configure do |config|
      config.domain = "somedomain.cloudfront.net"
      config.http_large_secret = "secret"
      config.aws_pem_file = File.join(File.dirname(__FILE__), "..", "pk-APKAIBJYP63EELSELVPQ.pem")
    end
  end

  context "when cdn type is small" do
    it "returns a open ended url with an expires time" do
      token = CDN::Cloudfront.generate_token("/my/file", :token => { :cdn_type => :small })
      token.should match(/Expires=/)
      token.should match(/Signature=/)
    end
  end

  context "when cdn type is large or nothing" do
    it "generates a signed url" do
      token = CDN::Cloudfront.generate_token("/my/file", allow_ip: "127.0.0.1")
      token.should match(/Policy=/)
    end
  end
end
