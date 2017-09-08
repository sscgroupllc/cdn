require "spec_helper"

describe CDN::Beluga do
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
      token = CDN::Beluga.generate_token("/my/file", :token => { :cdn_type => :small })
      expect(token).to eq("")
    end
  end

  context "when cdn type is large or nothing" do
    it "generates a hash of 32 characters" do
      token = CDN::Beluga.generate_token("/my/file")
      expect(token).to match(/token=([0-9A-Za-z]{32})/)
    end

    context "based on expiration" do
      context "when expires_in is empty" do
        it "generates a hash with an expiration of 0" do
          token = CDN::Beluga.generate_token("/my/file")
          expect(token).to match(/token=([0-9A-Za-z]{32})/)
          expect(token).to match(/expires=\d+/)
        end
      end

      context "when expires_in is not empty" do
        it "generates a hash based on the given expiration" do
          Timecop.freeze(Time.now.utc) do
            token = CDN::Beluga.generate_token("/my/file", expires_in: (Time.now.utc + (60 * 60 * 24)))
            expect(token).to match(/token=([0-9A-Za-z]{32})/)
            expect(token).to match(/expires=#{(Time.now.utc + ntp_drift + (60 * 60 * 24)).to_i}/)
          end
        end
      end
    end
  end
end
