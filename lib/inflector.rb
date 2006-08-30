require 'active_support/inflector'

# Introduce dutch variant for +ordinalize+ method.  The original english
# version is still available with a +english_+ prefix.
module Inflector
  ordinalize = instance_method(:ordinalize)
  define_method(:english_ordinalize) do |*args|
    ordinalize.bind(self).call(*args)
  end

  def dutch_ordinalize(n)
    case n % 100
      when 2..7, 9..19 then "#{n}de"
      else "#{n}ste"
    end
  end
  alias :ordinalize :dutch_ordinalize
end
