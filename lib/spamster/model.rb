require 'active_support/concern'
require 'spamster/model/proxy'

module Spamster
  module Model
    extend ActiveSupport::Concern

    included do
      spamster_attrs({})
    end

    module ClassMethods
      def spamster_attrs(attrs = nil)
        @spamster_attrs = attrs if attrs
        @spamster_attrs
      end
    end

    def spamster
      Proxy.new(self)
    end
  end
end