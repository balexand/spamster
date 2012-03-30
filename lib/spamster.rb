require 'net/http'
require 'spamster/version'
require 'uri'

module Spamster
  autoload :Rack, 'spamster/rack/middleware'

  class <<self
    attr_accessor :blog, :debug_output, :key, :request_params

    # see http://akismet.com/development/api/#verify-key
    def key_valid?
      check_config
      params = {:blog => blog, :key => key}
      response = perform_post("http://rest.akismet.com/1.1/verify-key", params)
      response.body == 'valid'
    end

    # see http://akismet.com/development/api/#comment-check
    def spam?(params)
      perform_spam_post("comment-check", params) == 'true'
    end

    # see http://akismet.com/development/api/#submit-spam
    def spam!(params)
      perform_spam_post("submit-spam", params)
    end

    # see http://akismet.com/development/api/#submit-ham
    def ham!(params)
      perform_spam_post("submit-ham", params)
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

    def perform_post(url, params)
      uri = URI(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.set_debug_output(debug_output) if debug_output

      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data(params)

      http.start { |h| h.request(req) }
    end

    # checks params and performs post for spam?, spam!, and ham!
    def perform_spam_post(method, params = {})
      check_config
      params = params.merge(:blog => blog)
      check_required_params(params)
      response = perform_post("http://#{key}.rest.akismet.com/1.1/#{method}", params)
      response.body
    end
  end
end
