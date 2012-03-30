require 'active_support/concern'

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

    def spam?
      Spamster.spam?(spamster_data)
    end

    def spam!
      Spamster.spam!(spamster_data)
    end

    def ham!
      Spamster.ham!(spamster_data)
    end

  private
    def spamster_data
      Hash[self.class.spamster_attrs.map do |param, method|
        [param, send(method)]
      end]
    end
  end
end