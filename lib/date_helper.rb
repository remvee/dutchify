require 'action_view/helpers/date_helper'

module ActionView
  module Helpers
    module DateHelper
      distance_of_time_in_words = instance_method(:distance_of_time_in_words)
      define_method(:english_distance_of_time_in_words) do |*args|
        distance_of_time_in_words.bind(self).call(*args)
      end

      def english_time_ago_in_words(from_time, include_seconds = false)
        english_distance_of_time_in_words(from_time, Time.now, include_seconds)
      end
      alias :english_distance_of_time_in_words_to_now :english_time_ago_in_words

      def dutch_distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
        from_time = from_time.to_time if from_time.respond_to?(:to_time)
        to_time = to_time.to_time if to_time.respond_to?(:to_time)
        distance_in_minutes = (((to_time - from_time).abs) / 60).round
        distance_in_seconds = ((to_time - from_time).abs).round

        case distance_in_minutes
          when 0..1
            return distance_in_minutes == 0 ? 'minder dan een minuut' : '1 minuut' unless include_seconds
            case distance_in_seconds
              when 0..5   then 'minder dan 5 seconden'
              when 6..10  then 'minder dan 10 seconden'
              when 11..20 then 'minder dan 20 seconden'
              when 21..40 then 'een halve minuut'
              when 41..59 then 'minder dan een minuut'
              else             '1 minuut'
            end
                      
          when 2..45      then "#{distance_in_minutes} minuten"
          when 46..90     then 'ongeveer 1 uur'
          when 90..1440   then "ongeveer #{(distance_in_minutes.to_f / 60.0).round} uur"
          when 1441..2880 then '1 dag'
          else                 "#{(distance_in_minutes / 1440).round} dagen"
        end
      end
      alias :distance_of_time_in_words :dutch_distance_of_time_in_words
    end
  end
end
