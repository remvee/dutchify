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


      number_to_human_size = instance_method(:number_to_human_size)
      define_method(:english_number_to_human_size) do |*args|
        number_to_human_size.bind(self).call(*args)
      end
      alias :english_human_size :english_number_to_human_size

      def dutch_number_to_human_size(size)
        english_number_to_human_size(size).tr('.', ',')
      end
      alias :number_to_human_size :dutch_number_to_human_size
      alias :human_size :dutch_number_to_human_size


      number_to_percentage = instance_method(:number_to_percentage)
      define_method(:english_number_to_percentage) do |*args|
        number_to_percentage.bind(self).call(*args)
      end

      def dutch_number_to_percentage(number, options = {})
        options = {:separator => ","}.merge(options)
        english_number_to_percentage(number, options)
      end
      alias :number_to_percentage :dutch_number_to_percentage


      number_with_delimiter = instance_method(:number_with_delimiter)
      define_method(:english_number_with_delimiter) do |*args|
        number_with_delimiter.bind(self).call(*args)
      end

      def dutch_number_with_delimiter(number, delimiter = '.', separator = ',')
        english_number_with_delimiter(number, delimiter, separator)
      end
      alias :number_with_delimiter :dutch_number_with_delimiter
    end
  end
end
