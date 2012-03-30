require 'spec_helper'

describe Spamster::Rack::Middleware do
  before(:each) do
    Spamster.use_akismet("123abc", "http://example.com/")
  end

  describe "call" do
    it "should set 'referrer', 'user_agent', and 'user_ip' request_params" do
      stub_request(:post, "http://123abc.rest.akismet.com/1.1/comment-check")

      app = Object.new
      app.stub(:call) do |env|
        Spamster.request_params.should == {
          :referrer   => 'http://referer.com/',
          :user_agent => 'Mozillaish',
          :user_ip    => "123.123.123.123"
        }

        Spamster.spam?(:comment_author => "Test User")
      end
      app.should_receive(:call).once
      Spamster::Rack::Middleware.new(app).call(
        'HTTP_REFERER' => 'http://referer.com/', 'HTTP_USER_AGENT' => 'Mozillaish', 'REMOTE_ADDR' => '123.123.123.123'
      )
      Spamster.request_params.should be_nil

      assert_requested(:post, "http://123abc.rest.akismet.com/1.1/comment-check", :times => 1) do |req|
        CGI.parse(req.body).should == {"comment_author"=>["Test User"], "blog"=>["http://example.com/"], "referrer"=>["http://referer.com/"], "user_agent"=>["Mozillaish"], "user_ip"=>["123.123.123.123"]}
      end
    end
  end
end