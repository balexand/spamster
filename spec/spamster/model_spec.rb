require 'spec_helper'

class Comment
  include Spamster::Model
  spamster_attrs :comment_author => :name, :comment_author_email => :email, :comment_content => :content
  attr_accessor :content, :email, :name
end

describe Spamster::Model do
  let(:comment) do
    Comment.new.tap do |c|
      c.content = "hello world"
      c.email = "test@example.com"
      c.name = "John"
    end
  end

  describe "spamster.data" do
    it "should get correct params from model" do
      comment.spamster.send(:data).should == {:comment_author => "John", :comment_author_email => "test@example.com", :comment_content => "hello world"}
    end
  end

  describe "spamster.spam?" do
    it "should pass params from model" do
      Spamster.should_receive(:spam?).once.with(:comment_author => "John", :comment_author_email => "test@example.com", :comment_content => "hello world")
      comment.spamster.spam?
    end
  end

  describe "spamster.spam!" do
    it "should pass params from model" do
      Spamster.should_receive(:spam!).once.with(:comment_author => "John", :comment_author_email => "test@example.com", :comment_content => "hello world")
      comment.spamster.spam!
    end
  end

  describe "spamster.ham!" do
    it "should pass params from model" do
      Spamster.should_receive(:ham!).once.with(:comment_author => "John", :comment_author_email => "test@example.com", :comment_content => "hello world")
      comment.spamster.ham!
    end
  end
end