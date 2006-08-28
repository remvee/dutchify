class String
  # Duplicate string and provide a return value for the +pluralize+ method.
  def with_plural(plural)
    r = dup
    r.instance_variable_set '@plural', plural
    def r.pluralize; @plural; end
    r
  end
end
