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
