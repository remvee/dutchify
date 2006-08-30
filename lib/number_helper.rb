require 'active_support'
require 'action_view/helpers/number_helper'

module ActionView
  module Helpers
    # Introduce dutch variants for +number_+ methods.  The original english
    # version are still available with a +english_+ prefix.
    module NumberHelper
      number_to_currency = instance_method(:number_to_currency)
      define_method(:english_number_to_currency) do |*args|
        number_to_currency.bind(self).call(*args)
      end

      def dutch_number_to_currency(number, options = {})
        options = {:unit => "&euro;", :separator => ",", :delimiter => "."}.merge(options)
        english_number_to_currency(number, options)
      end
      alias :number_to_currency :dutch_number_to_currency
    end
  end
end
