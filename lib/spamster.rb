require 'active_support'
require 'active_support/core_ext'
require 'net/http'
require 'spamster/version'
require 'uri'

module Spamster
  autoload :Model, 'spamster/model'
  autoload :Rack, 'spamster/rack/middleware'

  class <<self
    attr_accessor :api_host, :blog, :debug_output, :key, :request_params

    def use_akismet(key, blog)
      self.api_host = "rest.akismet.com"
      self.blog = blog
      self.key = key
    end

    def use_typepad(key, blog)
      self.api_host = "api.antispam.typepad.com"
      self.blog = blog
      self.key = key
    end

    # see http://akismet.com/development/api/#verify-key
    def key_valid?
      params = {:blog => blog, :key => key}
      response = perform_post("http://#{api_host}/1.1/verify-key", params)
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
    def perform_post(url, params)
      [:api_host, :blog, :key].each do |param|
        raise "'Spamster.#{param}' must be set" unless send(param).present?
      end

      uri = URI(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.set_debug_output(debug_output) if debug_output

      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data(params)
      # Akismet wants User-Agent format: Application Name/Version | Plugin Name/Version
      user_agent = "Spamster/#{VERSION}"
      user_agent = "Rails/#{Rails.version} | " + user_agent if defined?(Rails)
      req['User-Agent'] = user_agent

      http.start { |h| h.request(req) }
    end

    # checks params and performs post for spam?, spam!, and ham!
    def perform_spam_post(method, params = {})
      params = params.merge(:blog => blog)
      params.merge!(request_params) if request_params
      [:blog, :user_agent, :user_ip].each do |param|
        raise "required param #{param.inspect} is missing" unless params[param].present?
      end

      response = perform_post("http://#{key}.#{api_host}/1.1/#{method}", params)
      response.body
    end
  end
end
