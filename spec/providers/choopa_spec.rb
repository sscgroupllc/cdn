require "spec_helper"

describe CDN::Choopa do
  before do
    CDN.configure do |config|
      config.http_large_secret = "secret"
    end
  end

  context "when cdn type is small" do
    it "returns an empty string" do
      token = CDN::Choopa.generate_token("/my/file", :token => { :cdn_type => :small })
      token.should == ""
    end
  end

  context "when cdn type is large or nothing" do
    it "generates a hash of 20 characters" do
      token = CDN::Choopa.generate_token("/my/file")
      token.should match(/h=([0-9a-z]{32})/)
    end

    it "generates a hash with an expiration" do
      token = CDN::Choopa.generate_token("/my/file")
      token.should match(/e=([0-9a-z]{8})/)
    end
  end
end
