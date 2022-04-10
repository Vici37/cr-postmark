# Crystal Postmark

This shard provides an API client for the (Postmark Email API)[https://postmarkapp.com/developer] so that you can send emails from crystal.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     cr-postmark:
       github: vici37/cr-postmark
   ```

2. Run `shards install`

## Usage

```crystal
require "cr-postmark"

client = Postmark::ServerClient.new("SERVER_TOKEN")

resp = client.deliver_email(
  to: "destination@email.com",
  from: "myself@of.course",
  text_body: "Hello!"
  )

resp.error_code # => 0
resp.message # => "OK"
```

## Contributing

1. Fork it (<https://github.com/vici37/cr-postmark/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Troy Sornson](https://github.com/vici37) - creator and maintainer
