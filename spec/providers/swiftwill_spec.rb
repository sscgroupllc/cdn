require "spec_helper"

describe CDN::Swiftwill do
  let(:time_format) { "%Y%m%d%H%M%S" }
  let(:ntp_drift) { 30.seconds.to_i }

  before do
    CDN.configure do |config|
      config.http_large_secret = "secret"
      config.ntp_drift_seconds = ntp_drift
    end
  end

  context "when cdn type is small" do
    it "returns an empty string" do
      token = CDN::Swiftwill.generate_token("/my/file", :token => { :cdn_type => :small })
      token.should == ""
    end
  end

  context "when cdn type is large or nothing" do
    it "generates a hash of 20 characters" do
      token = CDN::Swiftwill.generate_token("/my/file")
      token.should match(/hash=0([0-9A-Za-z]{20})/)
    end

    it "generates a hash based on a client ip" do
      token = CDN::Swiftwill.generate_token("/my/file", :allow_ip => "192.168.0.1")
      token.should match(/hash=0([0-9A-Za-z]{20})/)
      token.should_not match(/clientip/)
      token.should_not match(/allow_ip/)
    end

    context "based on expiration" do
      context "when expires_in is empty" do
        it "generates a hash with an expiration of 0" do
          token = CDN::Swiftwill.generate_token("/my/file")
          token.should match(/hash=0([0-9A-Za-z]{20})/)
          token.should match(/nvb=\d{14}/)
          token.should match(/nva=\d{14}/)
        end
      end

      context "when expires_in is not empty" do
        it "generates a hash based on the given expiration" do
          Timecop.freeze(Time.now.utc) do
            token = CDN::Swiftwill.generate_token("/my/file", :expires_in => (Time.now.utc + 1.day))
            token.should match(/hash=0([0-9A-Za-z]{20})/)
            token.should match(/nvb=#{(Time.now.utc - ntp_drift).strftime(time_format)}/)
            token.should match(/nva=#{(Time.now.utc + ntp_drift + 1.day).strftime(time_format)}/)
          end
        end
      end
    end
  end
end
