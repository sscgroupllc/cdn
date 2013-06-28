CDN Gem

Provides an interface to various cdn services.

Usage:

```ruby
CDN.configure do |config|
  config.enabled = ENV['USE_CDN'] == 'true'
  config.provider = ENV['CDN_PROVIDER']
  config.domain = ENV['CDN_DOMAIN']
  config.small_domain = ENV['CDN_SMALL_DOMAIN']
  config.http_large_secret = ENV['CDN_LARGE_SECRET']
  config.http_small_secret = ENV['CDN_SMALL_SECRET']
end
```
