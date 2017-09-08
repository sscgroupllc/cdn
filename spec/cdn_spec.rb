require "spec_helper"

describe CDN do
  include CDN

  before do
    CDN.configure do |config|
      config.enabled = true
      config.provider = "TestProvider"
      config.domain = "localhost"
      config.http_large_secret = "secret"
      config.http_small_secret = "secret"
    end
  end

  describe "cdn_url" do
    it "appends to the query string if it already exists" do
      url = cdn_url("/system/content/videos/4810/screenshot_9484_thumb.jpg?1306909458")
      expect(url).to match(/1306909458/)
      expect(url).to match(/testtoken/)
    end
  end

  describe "cdn_large_url" do
    it "returns a url with a token" do
      url = cdn_large_url("/my/file")
      expect(url).to match(/testtoken/)
    end
  end

  describe "cdn_small_url" do
    it "returns a url with a token" do
      url = cdn_small_url("/my/file")
      expect(url).to match(/testtoken/)
    end
  end

  context "with a custom path processor" do
    before do
      CDN.configure do |config|
        config.path_processor = lambda { |p| "/modifiedpath" }
      end
    end

    it "modifies the path before generating the url" do
      url = cdn_url("/my/file")
      expect(url).to match(/modifiedpath/)
    end
  end
end
