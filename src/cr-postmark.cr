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

    def email_of(**kwargs) : Email
      Email.new(**kwargs)
    end

    def template_of(**kwargs) : TemplateEmail
      TemplateEmail.new(**kwargs)
    end

    def deliver_email(**kwargs) : EmailResponse
      deliver(email_of(**kwargs))
    end

    def deliver_template(**kwargs) : EmailResponse
      deliver(template_of(**kwargs))
    end

    def deliver_batch(letters : Array(Email) | Array(TemplateEmail)) : Array(EmailResponse)
      logger.debug { "Batch size of #{letters.size} being sent" }
      endpoint = letters.is_a?(Array(Email)) ? "email/batch" : "email/batchWithTemplates"
      make_call(endpoint, {Messages: letters}.to_json) do |resp|
        resp.status_code == 200 ? Array(EmailResponse).from_json(resp.body) : [EmailResponse.from_json(resp.body)]
      end
    end

    def deliver(email : Email | TemplateEmail) : EmailResponse
      endpoint = email.is_a?(Email) ? "email" : "email/withTemplate"
      make_call(endpoint, email.to_json) do |resp|
        EmailResponse.from_json(resp.body)
      end
    end

    private def make_call(endpoint, json)
      logger.debug { "Sending email to URL: #{@uri}#{endpoint}" }
      HTTP::Client.post("#{@uri}#{endpoint}", request_headers, json) do |resp|
        logger.debug { "Received a #{resp.status_code} status code" }
        yield resp
      end
    end
  end
end
