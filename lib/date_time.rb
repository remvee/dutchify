Date::MONTHNAMES = [nil] + %w{januari februari
    maart april mei juni juli augustus september oktober november december}
Date::MONTHNAMES.each_with_index { |v,i| Date::MONTHS[i] = v if v }

Date::ABBR_MONTHNAMES = [nil] + %w{jan feb maa
    apr mei jun jul aug sep okt nov dec}
Date::ABBR_MONTHNAMES.each_with_index { |v,i| Date::ABBR_MONTHS[i] = v if v }

Date::DAYNAMES = %w{zondag maandag dinsdag woensdag donderdag vrijdag zaterdag}
Date::DAYNAMES.each_with_index { |v,i| Date::DAYS[i] = v if v}

Date::ABBR_DAYNAMES = %w{zo ma di wo do vr za}
Date::ABBR_DAYNAMES.each_with_index { |v,i| Date::ABBR_DAYS[i] = v if v}

class Time # :nodoc:
  alias :strftime_nolocale :strftime
  def strftime(format)
    format = format.dup
    format.gsub!(/%a/, Date::ABBR_DAYNAMES[self.wday])
    format.gsub!(/%A/, Date::DAYNAMES[self.wday])
    format.gsub!(/%b/, Date::ABBR_MONTHNAMES[self.mon])
    format.gsub!(/%B/, Date::MONTHNAMES[self.mon])
    self.strftime_nolocale(format)
  end
end

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.update(
    :default => '%a %d %b %Y, %H:%M')
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.update(
    :default => '%a %d %b %Y')
