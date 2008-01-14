module ActionView
  module Helpers
    module ActiveRecordHelper
      # Geef een string terug met een <tt>DIV</tt> met daarin alle foutmeldingen voor de objecten waarvan de instantie variabel namen
      # gegeven zijn.  Als er meerder objecten gespecificieerd zijn, worden de foutmeldingen getoond in de volgorde dat de object
      # namen door gegeven zijn.
      #
      # Deze <tt>DIV</tt> kan aangepast worden met de volgende opties:
      #
      # * <tt>header_tag</tt> - Gebruikt in de kop van de foutmeldingen div (standaard: h2)
      # * <tt>id</tt> - Het id van de foutmeldingen div (standaard: errorExplanation)
      # * <tt>class</tt> - De class van de foutmeldingen div (standaard: errorExplanation)
      # * <tt>object_name</tt> - De object naam om te gebruiken in de kop, of een andere tekst.  Als <tt>object_name</tt> niet gegeven wordt, wordt van het eerste object de <tt>human_name</tt> class methode geprobeerd.  Als die methode niet beschikbaar is, wordt de eerste gegeven object naam gebruikt.
      #
      # Voorbeelden:
      #
      #   error_messages_for :user
      #
      #   error_messages_for :user, :address, :object_name => 'gebruiker'
      def error_messages_for(*params)
        options = Hash === params.last ? params.pop.symbolize_keys : {}
        objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }
        count   = objects.compact.inject(0) {|sum, object| sum + object.errors.count }
        unless count.zero?
          html = {}
          [:id, :class].each do |key|
            if options.include?(key)
              value = options[key]
              html[key] = value unless value.blank?
            else
              html[key] = 'errorExplanation'
            end
          end
          human_name = if options[:object_name]
            options[:object_name]
          elsif objects.first && objects.first.class.respond_to?(:human_name)
            objects.first.class.human_name
          else
            params.first.to_s.gsub('_', ' ')
          end
          header_message = "Vanwege #{pluralize(count, 'probleem', 'problemen')} kan #{human_name} niet opgeslagen worden"
          error_messages = objects.map {|object| object.errors.full_messages.map {|msg| content_tag(:li, msg) } }
          content_tag(:div,
            content_tag(options[:header_tag] || :h2, header_message) <<
              content_tag(:p, count == 1 ? 'Er is een probleem met het volgende veld:' : 'Er zijn problemen met de volgende velden:') <<
              content_tag(:ul, error_messages),
            html
          )
        else
          ''
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
