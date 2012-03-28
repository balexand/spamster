require 'spec_helper'

describe Spamster::Rack::Middleware do
  describe "call" do
    it "should set 'referrer', 'user_agent', and 'user_ip' request_params" do
      app = Object.new
      app.stub(:call) do |env|
        Spamster.request_params.should == {
          :referrer   => 'http://referer.com/',
          :user_agent => 'Mozillaish',
          :user_ip    => "123.123.123.123"
        }
      end
      app.should_receive(:call).once
      Spamster::Rack::Middleware.new(app).call(
        'HTTP_REFERER' => 'http://referer.com/', 'HTTP_USER_AGENT' => 'Mozillaish', 'REMOTE_ADDR' => '123.123.123.123'
      )
      Spamster.request_params.should be_nil
    end
  end
end