require 'net/http'
require 'spamster/version'

module Spamster
  class <<self
    attr_accessor :blog, :key

    # see http://akismet.com/development/api/#verify-key
    def key_valid?
      check_config
      params = {blog: blog, key: key}
      response = Net::HTTP.post_form(URI("http://rest.akismet.com/1.1/verify-key"), params)
      response.body == 'valid'
    end

    # see http://akismet.com/development/api/#comment-check
    def spam?(params)
      submit("comment-check", params) == 'true'
    end

    # see http://akismet.com/development/api/#submit-spam
    def spam!(params)
      submit("submit-spam", params)
    end

    # see http://akismet.com/development/api/#submit-ham
    def ham!(params)
      submit("submit-ham", params)
    end

  private
    def check_config
      raise "'Spamster.blog' must be set" unless blog
      raise "'Spamster.key' must be set"  unless key
    end

    def check_required_params(params)
      # these params are required by spam?, spam!, and ham!
      [:blog, :user_agent, :user_ip].each do |param|
        raise "required param #{param.inspect} is missing" unless params[param]
      end
    end

    def submit(method, params = {})
      check_config
      params = params.merge(blog: blog)
      check_required_params(params)
      response = Net::HTTP.post_form(URI("http://#{key}.rest.akismet.com/1.1/#{method}"), params)
      response.body
    end
  end
end

# FIXME User-Agent
