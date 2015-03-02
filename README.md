# CDN Gem

Provides an interface to various cdn services.

## Configure
```ruby
CDN.configure do |config|
  config.enabled = true
  config.provider = "MyProvider"
  config.domain = "mydomain.com"
  config.http_large_secret = "secret"
  config.http_small_secret = "secret"
end
```

The CDN module uses provider classes for
the actual implementation of each service.
A provider class needs to implement two methods
for compliance.

```ruby
generate_token(file_name, options)
generate_url(options)
```

Each of the methods should return a string
To use the helper, include the module.

```ruby
class ApplicationController
  include CDN
end
```

And then simply call the helper.

```ruby
  cdn_large_url("/path/to/my/file")
```

It can also be called with options.

```ruby
cdn_large_url("/path/to/my/file",
              protocol: "https",
              domain: "mydomain.com",
              token: { expires_in: 1.day })
```
