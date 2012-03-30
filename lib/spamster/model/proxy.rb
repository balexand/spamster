module Spamster
  module Model
    class Proxy
      def initialize(model)
        @model = model
      end

      def spam?
        Spamster.spam?(data)
      end

      def spam!
        Spamster.spam!(data)
      end

      def ham!
        Spamster.ham!(data)
      end

    private
      def data
        Hash[@model.class.spamster_attrs.map do |param, method|
          [param, @model.send(method)]
        end]
      end
    end
  end
end

