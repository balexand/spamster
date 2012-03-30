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

  describe "spamster_data" do
    it "should get correct params from model" do
      comment.send(:spamster_data).should == {:comment_author => "John", :comment_author_email => "test@example.com", :comment_content => "hello world"}
    end
  end

  describe "spam?" do
    it "should pass params from model" do
      Spamster.should_receive(:spam?).once.with(:comment_author => "John", :comment_author_email => "test@example.com", :comment_content => "hello world")
      comment.spam?
    end
  end

  describe "spam!" do
    it "should pass params from model" do
      Spamster.should_receive(:spam!).once.with(:comment_author => "John", :comment_author_email => "test@example.com", :comment_content => "hello world")
      comment.spam!
    end
  end

  describe "ham!" do
    it "should pass params from model" do
      Spamster.should_receive(:ham!).once.with(:comment_author => "John", :comment_author_email => "test@example.com", :comment_content => "hello world")
      comment.ham!
    end
  end
end