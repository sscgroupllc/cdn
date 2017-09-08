require "spec_helper"

describe CDN::Swiftwill do
  let(:time_format) { "%Y%m%d%H%M%S" }
  let(:ntp_drift) { 30 }

  before do
    CDN.configure do |config|
      config.http_large_secret = "secret"
      config.ntp_drift_seconds = ntp_drift
    end
  end

  context "when cdn type is small" do
    it "returns an empty string" do
      token = CDN::Swiftwill.generate_token("/my/file", :token => { :cdn_type => :small })
      expect(token).to eq("")
    end
  end

  context "when cdn type is large or nothing" do
    it "generates a hash of 20 characters" do
      token = CDN::Swiftwill.generate_token("/my/file")
      expect(token).to match(/hash=0([0-9A-Za-z]{20})/)
    end

    it "generates a hash based on a client ip" do
      token = CDN::Swiftwill.generate_token("/my/file", :allow_ip => "192.168.0.1")
      expect(token).to match(/hash=0([0-9A-Za-z]{20})/)
      expect(token).to_not match(/clientip/)
      expect(token).to_not match(/allow_ip/)
    end

    context "based on expiration" do
      context "when expires_in is empty" do
        it "generates a hash with an expiration of 0" do
          token = CDN::Swiftwill.generate_token("/my/file")
          expect(token).to match(/hash=0([0-9A-Za-z]{20})/)
          expect(token).to match(/nvb=\d{14}/)
          expect(token).to match(/nva=\d{14}/)
        end
      end

      context "when expires_in is not empty" do
        it "generates a hash based on the given expiration" do
          Timecop.freeze(Time.now.utc) do
            token = CDN::Swiftwill.generate_token("/my/file", :expires_in => (Time.now.utc + (60 * 60 * 24)))
            expect(token).to match(/hash=0([0-9A-Za-z]{20})/)
            expect(token).to match(/nvb=#{(Time.now.utc - ntp_drift).strftime(time_format)}/)
            expect(token).to match(/nva=#{(Time.now.utc + ntp_drift + (60 * 60 * 24)).strftime(time_format)}/)
          end
        end
      end
    end
  end
end
