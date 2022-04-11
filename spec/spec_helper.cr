require "spectator"
require "webmock"
require "../src/cr-postmark"

Spectator.configure do |config|
  config.before_each { WebMock.reset }
end
