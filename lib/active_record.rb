module ActionView # :nodoc:
  module Helpers # :nodoc:
    module ActiveRecordHelper # :nodoc:
      def error_messages_for(object_name, options = {})
        options = options.symbolize_keys
        object = instance_variable_get("@#{object_name}")
        human_name = object.class.respond_to?(:human_name) ? object.class.human_name : object.class.name
        unless object.errors.empty?
          content_tag("div",
            content_tag(
              options[:header_tag] || "h2",
              (object.errors.size == 1 ? 
                  "Vanwege het volgende probleem kon #{human_name} niet opgeslagen worden." :
                  "Vanwege de volgende problemen kon #{human_name} niet opgeslagen worden.")
            ) +
            (object.errors.size == 1 ? 
                content_tag("p", "Er is een probleem met het volgende veld:") :
                content_tag("p", "Er zijn problemen met de volgende velden:")) +
            content_tag("ul", object.errors.full_messages.collect { |msg| content_tag("li", msg) }),
            "id" => options[:id] || "errorExplanation", "class" => options[:class] || "errorExplanation" 
          )
        end
      end
    end
  end
end

ActiveRecord::Errors.default_error_messages = {
  :inclusion => "valt niet binnen de lijst",
  :exclusion => "is gereserveerd",
  :invalid => "is niet geldig",
  :confirmation => "komt niet overeen met bevestiging",
  :accepted  => "moet geaccepteerd worden",
  :empty => "mag niet leeg zijn",
  :blank => "mag niet blanco zijn",
  :too_long => "is te lang (max is %d karakters)",
  :too_short => "is te kort (min is %d karakters)",
  :wrong_length => "is de verkeerde lengte (moet zijn %d karakters)",
  :taken => "wordt al gebruikt",
  :not_a_number => "is geen getal" 
}

# Fixes for not properly converting Date objects to their database equivalents.
module ActiveRecord # :nodoc:
  module ConnectionAdapters # :nodoc:
    module Quoting # :nodoc:
      def quote(value, column = nil)
        case value
          when String
            if column && column.type == :binary && column.class.respond_to?(:string_to_binary)
              "'#{quote_string(column.class.string_to_binary(value))}'" # ' (for ruby-mode)
            elsif column && [:integer, :float].include?(column.type) 
              value.to_s
            else
              "'#{quote_string(value)}'" # ' (for ruby-mode)
            end
          when NilClass              then "NULL"
          when TrueClass             then (column && column.type == :integer ? '1' : quoted_true)
          when FalseClass            then (column && column.type == :integer ? '0' : quoted_false)
          when Float, Fixnum, Bignum then value.to_s
          when Date                  then "'#{value.strftime("%Y-%m-%d")}'"
          when Time, DateTime        then "'#{quoted_date(value)}'"
          else                            "'#{quote_string(value.to_yaml)}'"
        end
      end
    end

    class SQLServerAdapter < AbstractAdapter # :nodoc:
      def quote(value, column = nil)
        case value
          when String                
            if column && column.type == :binary && column.class.respond_to?(:string_to_binary)
              "'#{quote_string(column.class.string_to_binary(value))}'"
            else
              "'#{quote_string(value)}'"
            end
          when NilClass              then "NULL"
          when TrueClass             then '1'
          when FalseClass            then '0'
          when Float, Fixnum, Bignum then value.to_s
          when Date                  then "'#{value.strftime("%Y-%m-%d")}'"
          when Time, DateTime        then "'#{value.strftime("%Y-%m-%d %H:%M:%S")}'"
          else                            "'#{quote_string(value.to_yaml)}'"
        end
      end
    end
    
    class SybaseAdapter < AbstractAdapter # :nodoc:
      def quote(value, column = nil)
        case value
          when String                
            if column && column.type == :binary && column.class.respond_to?(:string_to_binary)
              "#{quote_string(column.class.string_to_binary(value))}"
            elsif value =~ /^[+-]?[0-9]+$/o
              value
            else
              "'#{quote_string(value)}'"
            end
          when NilClass              then (column && column.type == :boolean) ? '0' : "NULL"
          when TrueClass             then '1'
          when FalseClass            then '0'
          when Float, Fixnum, Bignum then value.to_s
          when Date                  then "'#{value.strftime("%Y-%m-%d")}'" 
          when Time, DateTime        then "'#{value.strftime("%Y-%m-%d %H:%M:%S")}'"
          else                            "'#{quote_string(value.to_yaml)}'"
        end
      end
    end
    
    class FirebirdAdapter < AbstractAdapter # :nodoc:
      def quote(value, column = nil)
        if [Time, DateTime].include?(value.class)
          "CAST('#{value.strftime("%Y-%m-%d %H:%M:%S")}' AS TIMESTAMP)"
        elsif value.class == Date
          "CAST('#{value.strftime("%Y-%m-%d")}' AS DATE)"
        else
          super
        end
      end
    end
  
    class SybaseAdapter < AbstractAdapter # :nodoc:
      def quote(value, column = nil)
        case value
          when String                
            if column && column.type == :binary && column.class.respond_to?(:string_to_binary)
              "#{quote_string(column.class.string_to_binary(value))}"
            elsif value =~ /^[+-]?[0-9]+$/o
              value
            else
              "'#{quote_string(value)}'"
            end
          when NilClass              then (column && column.type == :boolean) ? '0' : "NULL"
          when TrueClass             then '1'
          when FalseClass            then '0'
          when Float, Fixnum, Bignum then value.to_s
          when Date                  then "'#{value.strftime("%Y-%m-%d")}'" 
          when Time, DateTime        then "'#{value.strftime("%Y-%m-%d %H:%M:%S")}'"
          else                            "'#{quote_string(value.to_yaml)}'"
        end
      end
    end
  end
end