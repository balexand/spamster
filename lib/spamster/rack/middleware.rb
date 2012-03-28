module Spamster
  module Rack
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        params = {}
        params[:referrer]    = env['HTTP_REFERER'] if env['HTTP_REFERER']
        params[:user_agent]  = env['HTTP_USER_AGENT'] if env['HTTP_USER_AGENT']
        params[:user_ip]     = env['REMOTE_ADDR'] if env['REMOTE_ADDR']
        Spamster.request_params = params

        response = @app.call(env)

        Spamster.request_params = nil
        response
      end
    end
  end
end