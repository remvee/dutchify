require 'active_support'

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


  underscore = instance_method(:underscore)
  define_method(:english_underscore) do |*args|
    underscore.bind(self).call(*args)
  end

  def dutch_underscore(camel_cased_word)
    camel_cased_word.to_s.gsub(/::/, '/').
      gsub(/([a-z\d])(IJ|[A-Z])/, '\1_\2').
      gsub(/([A-Z]+?)(IJ[a-z])/, '\1_\2').
      gsub(/([A-HJ-Z]+)([A-IK-Z][a-z])/, '\1_\2').
      tr("- ", "_").
      downcase
  end
  alias :underscore :dutch_underscore


  titleize = instance_method(:titleize)
  define_method(:english_titleize) do |*args|
    titleize.bind(self).call(*args)
  end

  def dutch_titleize(word)
    humanize(underscore(word)).gsub(/\b(ij|[a-z])/i) { $1.upcase }
  end
  alias :titleize :dutch_titleize


  camelize = instance_method(:camelize)
  define_method(:english_camelize) do |*args|
    camelize.bind(self).call(*args)
  end

  def dutch_camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
    if first_letter_in_uppercase
      lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(ij|.)/) { $2.upcase }
    else
      lower_case_and_underscored_word.first + camelize(lower_case_and_underscored_word)[1..-1]
    end
  end
  alias :camelize :dutch_camelize
end


class String
  # Duplicate string and provide a return value for the +pluralize+ method.
  def with_plural(plural)
    singular, plural = dup, plural.dup
    prepare_pluralizer(singular, plural)
    singular
  end

  # Duplicate string and provide a return value for the +singularize+ method.
  def with_singular(singular)
    singular, plural = singular.dup, dup
    prepare_pluralizer(singular, plural)
    plural
  end

private
  def prepare_pluralizer(singular, plural)
    singular.instance_variable_set '@plural', plural
    plural.instance_variable_set '@singular', singular

    def singular.pluralize; @plural; end
    def plural.singularize; @singular; end
  end
end
