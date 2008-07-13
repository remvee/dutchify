require 'active_record/version'

if ("%02d%03d%05d" % [ActiveRecord::VERSION::MAJOR, ActiveRecord::VERSION::MINOR, ActiveRecord::VERSION::TINY]) < '0200100000'
  # Fixes for not properly converting Date objects to their database equivalents.
  module ActiveRecord # :nodoc:
    module ConnectionAdapters # :nodoc:
      module Quoting # :nodoc:
        def quote(value, column = nil)
          return value.quoted_id if value.respond_to?(:quoted_id)

          case value
            when String, ActiveSupport::Multibyte::Chars
              value = value.to_s
              if column && column.type == :binary && column.class.respond_to?(:string_to_binary)
                "'#{quote_string(column.class.string_to_binary(value))}'" # ' (for ruby-mode)
              elsif column && [:integer, :float].include?(column.type)
                value = column.type == :integer ? value.to_i : value.to_f
                value.to_s
              else
                "'#{quote_string(value)}'" # ' (for ruby-mode)
              end
            when NilClass              then "NULL"
            when TrueClass             then (column && column.type == :integer ? '1' : quoted_true)
            when FalseClass            then (column && column.type == :integer ? '0' : quoted_false)
            when Float, Fixnum, Bignum then value.to_s
            # BigDecimals need to be output in a non-normalized form and quoted.
            when BigDecimal               then value.to_s('F')
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
end
