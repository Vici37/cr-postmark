require "./spec_helper"

Spectator.configure do |config|
  config.before_each { WebMock.reset }
end

Spectator.describe Postmark::ServerClient do
  it "sends email" do
    WebMock.stub(:post, "https://api.postmarkapp.com/email")
      .with(headers: {"X-Postmark-Server-Token" => "token"})
      .to_return(status: 200, body: %q({"To":"you","SubmittedAt":"now","MessageID":"1","ErrorCode":0,"Message":"success"}))

    client = Postmark::ServerClient.new("token")
    resp = client.deliver_email(to: "you", from: "me", text_body: "nope")
    expect(resp.to).to eq "you"
    expect(resp.message).to eq "success"
  end
end
