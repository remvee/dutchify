module Inflector
  def ordinalize(n)
    case n % 100
      when 2..7, 9..19 then "#{n}de"
      else "#{n}ste"
    end
  end
end