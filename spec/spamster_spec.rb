require 'spec_helper'

describe Spamster do
  before(:each) do
    Spamster.blog = "http://example.com/"
    Spamster.key = "123abc"
  end

  describe "perform_post" do
    before(:each) do
      stub_request(:post, "http://123abc.rest.akismet.com/1.1/comment-check")
    end

    it "should raise exception if :blog is not configured" do
      Spamster.blog = nil
      expect do
        Spamster.send(:perform_post, "http://123abc.rest.akismet.com/1.1/comment-check", {})
      end.to raise_exception{ |e| e.message.should == "'Spamster.blog' must be set" }
    end

    it "should raise exception if :key is not configured" do
      Spamster.key = nil
      expect do
        Spamster.send(:perform_post, "http://123abc.rest.akismet.com/1.1/comment-check", {})
      end.to raise_exception{ |e| e.message.should == "'Spamster.key' must be set" }
    end

    it "should set User-Agent" do
      Spamster.send(:perform_post, "http://123abc.rest.akismet.com/1.1/comment-check", {})
      assert_requested(:post, "http://123abc.rest.akismet.com/1.1/comment-check", :times => 1, :headers => {'User-Agent' => "Spamster/#{Spamster::VERSION}"})

      class Rails
        def self.version
          "3.2.2"
        end
      end

      Spamster.send(:perform_post, "http://123abc.rest.akismet.com/1.1/comment-check", {})
      assert_requested(:post, "http://123abc.rest.akismet.com/1.1/comment-check", :times => 1, :headers => {'User-Agent' => "Rails/3.2.2 | Spamster/#{Spamster::VERSION}"})
      Object.send(:remove_const, :Rails)
    end
  end

  describe "key_valid?" do
    it "should return true with valid response" do
      stub_request(:post, "http://rest.akismet.com/1.1/verify-key").to_return(:body => "valid")
      Spamster.key_valid?.should == true
      assert_requested(:post, "http://rest.akismet.com/1.1/verify-key", :times => 1) do |req|
        CGI.parse(req.body).should == {"blog" => ["http://example.com/"], "key" => ["123abc"]}
        true
      end
    end

    it "should return false with invalid response" do
      stub_request(:post, "http://rest.akismet.com/1.1/verify-key").to_return(:body => "invalid")
      Spamster.key_valid?.should == false
      assert_requested(:post, "http://rest.akismet.com/1.1/verify-key", :times => 1) do |req|
        CGI.parse(req.body).should == {"blog" => ["http://example.com/"], "key" => ["123abc"]}
        true
      end
    end
  end

  describe "spam?" do
    it "should return true if spam" do
      stub_request(:post, "http://123abc.rest.akismet.com/1.1/comment-check").to_return(:body => "true")
      Spamster.spam?(:user_ip => "222.222.222.222", :user_agent => "Mozilla", :comment_author => "viagra-test-123").should == true
      assert_requested(:post, "http://123abc.rest.akismet.com/1.1/comment-check", :times => 1) do |req|
        CGI.parse(req.body).should == {"user_ip"=>["222.222.222.222"], "user_agent"=>["Mozilla"], "comment_author"=>["viagra-test-123"], "blog"=>["http://example.com/"]}
        true
      end
    end

    it "should return false if not spam" do
      stub_request(:post, "http://123abc.rest.akismet.com/1.1/comment-check").to_return(:body => "false")
      Spamster.spam?(:user_ip => "222.222.222.222", :user_agent => "Mozilla").should == false
      assert_requested(:post, "http://123abc.rest.akismet.com/1.1/comment-check", :times => 1) do |req|
        CGI.parse(req.body).should == {"user_ip"=>["222.222.222.222"], "user_agent"=>["Mozilla"], "blog"=>["http://example.com/"]}
        true
      end
    end

    it "should raise exception if required param missing" do
      expect do
        Spamster.spam?(:user_ip => "222.222.222.222")
      end.to raise_exception{ |e| e.message.should == "required param :user_agent is missing" }

      expect do
        Spamster.spam?(:user_agent => "Mozilla")
      end.to raise_exception{ |e| e.message.should == "required param :user_ip is missing" }
    end
  end

  describe "spam!" do
    it "should submit request" do
      stub_request(:post, "http://123abc.rest.akismet.com/1.1/submit-spam").to_return(:body => "Thanks for making the web a better place.")
      Spamster.spam!(:user_ip => "222.222.222.222", :user_agent => "Mozilla", :comment_author => "viagra-test-123")
      assert_requested(:post, "http://123abc.rest.akismet.com/1.1/submit-spam", :times => 1) do |req|
        CGI.parse(req.body).should == {"user_ip"=>["222.222.222.222"], "user_agent"=>["Mozilla"], "comment_author"=>["viagra-test-123"], "blog"=>["http://example.com/"]}
        true
      end
    end
  end

  describe "ham!" do
    it "should submit request" do
      stub_request(:post, "http://123abc.rest.akismet.com/1.1/submit-ham").to_return(:body => "Thanks for making the web a better place.")
      Spamster.ham!(:user_ip => "222.222.222.222", :user_agent => "Mozilla", :comment_author => "viagra-test-123")
      assert_requested(:post, "http://123abc.rest.akismet.com/1.1/submit-ham", :times => 1) do |req|
        CGI.parse(req.body).should == {"user_ip"=>["222.222.222.222"], "user_agent"=>["Mozilla"], "comment_author"=>["viagra-test-123"], "blog"=>["http://example.com/"]}
        true
      end
    end
  end
end