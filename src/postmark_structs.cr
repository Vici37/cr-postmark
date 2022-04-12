module Postmark
  macro json_record(name, *properties)
    class {{name.id}}
      include JSON::Serializable

      {% for property in properties %}
      @[JSON::Field(key: "{{property.var.id.camelcase.id}}")]
      getter {{property}}
      {% end %}

      def initialize({{
                       *properties.map do |field|
                         "@#{field.id}".id
                       end
                     }})
        validate
      end

      def validate; end

      {{yield}}
    end
  end

  json_record Email,
    from : String,
    to : String,
    html_body : String? = nil,
    text_body : String? = nil,
    cc : String? = nil,
    bcc : String? = nil,
    subject : String? = nil,
    tag : String? = nil,
    reply_to : String? = nil,
    headers : Array(NamedTuple(name: String, value: String))? = nil,
    track_opens : Bool? = nil,
    track_links : Bool? = nil,
    metadata : Hash(String, String)? = nil,
    attachments : Array(Attachement)? = nil,
    message_stream : String? = nil do
    def validate
      raise "Postmark emails require either `html_body` or `text_body`" if @html_body.nil? && @text_body.nil?
      raise "Postmark emails can only have `html_body` or `text_body`, not both" if @html_body && @text_body
    end
  end

  json_record Attachement,
    name : String,
    content : String,
    content_type : String,
    content_id : String? = nil

  json_record TemplateEmail,
    to : String,
    from : String,
    template_model : JSON::Serializable | Hash(String, String),
    template_id : String? = nil,
    template_alias : String? = nil,
    cc : String? = nil,
    bcc : String? = nil,
    tag : String? = nil,
    reply_to : String? = nil,
    headers : Array(NamedTuple(name: String, value: String))? = nil,
    metadata : Hash(String, String)? = nil,
    attachments : Array(Attachement)? = nil,
    message_stream : String? = nil,
    inline_css : Bool? = nil,
    track_opens : Bool? = nil,
    track_links : Bool? = nil do
    def validate
      raise "Templates require either `template_id` or `template_alias`" if @template_id.nil? && @template_alias.nil?
      raise "Templates can only have either `template_id` or `template_alias`, not both" if @template_id && @template_alias
    end
  end

  # This gets the hand crafted treatment, because otherwise `message_id` turns into `MessageId`, when
  # it should be `MessageID`. Doesn't happen with `template_id` above, only this one.
  class EmailResponse
    include JSON::Serializable

    @[JSON::Field(key: "To")]
    getter to : String? = nil
    @[JSON::Field(key: "SubmittedAt")]
    getter submitted_at : String? = nil
    @[JSON::Field(key: "MessageID")]
    getter message_id : String? = nil
    @[JSON::Field(key: "ErrorCode")]
    getter error_code : Int32
    @[JSON::Field(key: "Message")]
    getter message : String

    def initialize(@to : String, @submitted_at : String, @message_id : String, @error_code : Int32, @message : String)
    end
  end
end
