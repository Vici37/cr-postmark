# Crystal Postmark

This shard provides an API client for the (Postmark Email API)[https://postmarkapp.com/developer] so that you can send emails from crystal.

Right now this shard only supports:

* Sending email
* Sending templated email
* Sending batched email
* Sending batched templated email

There are currently no plans to expand to the rest of the Postmark API, but Pull Requests would be
reviewed and accepted if they provided the functionality :)

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

# Initialize the client with your server token
client = Postmark::ServerClient.new("SERVER_TOKEN")

# And begin sending email immediately
resp = client.deliver_email(
  to: "destination@email.com",
  from: "myself@of.course",
  subject: "Hello World!"
  text_body: "Hello!"
)

resp.error_code # => 0
resp.message # => "OK"

# Can send templated email too
client.deliver_template(
  to: "destination@email.com",
  from: "myself@of.course",
  template_alias: "welcome-email",
  # The template model can be a Hash(String, String),
  # or any JSON::Serializable object for custom models
  template_model: {"name" => "Art Vandelay"}
)

# Sending batches is easy
client.deliver_batch([
  client.email_of(to: "destination_1@email.com", from: "myself@of.course", subject: "Email 1", html_body: "<span>Hello World!</span>"),
  client.email_of(to: "destination_2@email.com", from: "myself@of.course", subject: "Email 2", text_body: "Hello World!", message_stream: "other-outbound")
])

# Including batched templates with custom models
class MyModel
  include JSON::Serializable

  getter name : String

  def initialize(@name : String); end
end

client.deliver_template([
  client.template_of(to: "another@destination.email", from: "myself@of.course", template_id: "1234", template_model: MyModel.new("Art Vandelay"))
])
```

## Contributing

1. Fork it (<https://github.com/vici37/cr-postmark/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Troy Sornson](https://github.com/vici37) - creator and maintainer
