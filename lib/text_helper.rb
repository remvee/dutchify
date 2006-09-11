module ActionView
  module Helpers
    # Introduce dutch variants for +time_ago_in_words+ methods.  The original
    # english version are still available with a +english_+ prefix.
    module TextHelper
      pluralize = instance_method(:pluralize)
      define_method(:english_pluralize) do |*args|
        pluralize.bind(self).call(*args)
      end
      
      def dutch_pluralize(count, singular, plural = nil)
        english_pluralize(count, singular, plural || singular.pluralize)
      end
      alias :pluralize :dutch_pluralize
    end
  end
end