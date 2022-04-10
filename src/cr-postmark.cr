require "json"
require "http"
require "base64"
require "./postmark_structs"

module Postmark
  class ServerClient
    def initialize(@token : String, address : String = "https://api.postmarkapp.com/")
      @uri = URI.parse(address)
      @logger = ::Log.for(ServerClient)
    end

    private def logger
      @logger
    end

    private def request_headers
      HTTP::Headers{
        "X-Postmark-Server-Token" => @token,
        "Accept"                  => "application/json",
        "Content-Type"            => "application/json",
      }
    end

    def deliver_email(
      **kwargs
    )
      deliver(Email.new(**kwargs))
    end

    def deliver_template(
      **kwargs
    )
      deliver(TemplateEmail.new(**kwargs))
    end

    def deliver(email : Email | TemplateEmail)
      endpoint = email.is_a?(Email) ? "email" : "email/withTemplate"
      resp = HTTP::Client.post("#{@uri}#{endpoint}", request_headers, email.to_json)
      EmailResponse.from_json(resp.body)
    end
  end
end
