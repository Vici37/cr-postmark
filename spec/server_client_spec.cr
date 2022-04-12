require "./spec_helper"

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

  it "sends template email" do
    WebMock.stub(:post, "https://api.postmarkapp.com/email/withTemplate")
      .with(headers: {"X-Postmark-Server-Token" => "token"})
      .to_return(status: 200, body: %q({"To":"you","SubmittedAt":"now","MessageID":"1","ErrorCode":0,"Message":"success"}))

    client = Postmark::ServerClient.new("token")
    resp = client.deliver_template(to: "you", from: "me", template_model: {"success" => "yes"}, template_alias: "alias")
    expect(resp.to).to eq "you"
    expect(resp.message).to eq "success"
  end

  it "sends batch emails" do
    WebMock.stub(:post, "https://api.postmarkapp.com/email/batch")
      .with(headers: {"X-Postmark-Server-Token" => "token"})
      .to_return(status: 200, body: %q([{"To":"you","SubmittedAt":"now","MessageID":"1","ErrorCode":0,"Message":"success"}]))

    client = Postmark::ServerClient.new("token")
    resp = client.deliver_batch([client.email_of(to: "you", from: "me", text_body: "nope")])
    expect(resp.size).to eq 1
    expect(resp[0].to).to eq "you"
    expect(resp[0].message).to eq "success"
  end

  it "sends batch template emails" do
    WebMock.stub(:post, "https://api.postmarkapp.com/email/batchWithTemplates")
      .with(headers: {"X-Postmark-Server-Token" => "token"})
      .to_return(status: 200, body: %q([{"To":"you","SubmittedAt":"now","MessageID":"1","ErrorCode":0,"Message":"success"}]))

    client = Postmark::ServerClient.new("token")
    resp = client.deliver_batch([client.template_of(to: "you", from: "me", template_model: {"success" => "yes"}, template_alias: "alias")])
    expect(resp.size).to eq 1
    expect(resp[0].to).to eq "you"
    expect(resp[0].message).to eq "success"
  end
end
