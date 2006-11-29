require 'active_support'

module ActiveSupport::CoreExtensions::Array::Conversions
  alias orig_to_sentence to_sentence
  def to_sentence(options = {})
    options.reverse_merge! :connector => 'en', :skip_last_comma => true
    orig_to_sentence(options)
  end
end
