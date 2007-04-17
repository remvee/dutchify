DutchifyDateFormat = RUBY_VERSION >= "1.8.6" ? Date::Format : Date
  
Date::MONTHNAMES = [nil] + %w{januari februari maart april mei juni juli augustus september oktober november december}
DutchifyDateFormat::MONTHS = {}
Date::MONTHNAMES.each_with_index { |v,i| DutchifyDateFormat::MONTHS[v] = i if v }

Date::ABBR_MONTHNAMES = [nil] + %w{jan feb maa apr mei jun jul aug sep okt nov dec}
DutchifyDateFormat::ABBR_MONTHS = {}
Date::ABBR_MONTHNAMES.each_with_index { |v,i| DutchifyDateFormat::ABBR_MONTHS[v] = i if v }

Date::DAYNAMES = %w{zondag maandag dinsdag woensdag donderdag vrijdag zaterdag}
DutchifyDateFormat::DAYS = {}
Date::DAYNAMES.each_with_index { |v,i| DutchifyDateFormat::DAYS[v] = i }

Date::ABBR_DAYNAMES = %w{zo ma di wo do vr za}
DutchifyDateFormat::ABBR_DAYS = {}
Date::ABBR_DAYNAMES.each_with_index { |v,i| DutchifyDateFormat::ABBR_DAYS[v] = i }

[Date, Time].each do |c|
  c.module_eval <<-END
    alias :strftime_nolocale :strftime
    def strftime(format)
      format = format.dup
      format.gsub!(/%a/, Date::ABBR_DAYNAMES[self.wday])
      format.gsub!(/%A/, Date::DAYNAMES[self.wday])
      format.gsub!(/%b/, Date::ABBR_MONTHNAMES[self.mon])
      format.gsub!(/%B/, Date::MONTHNAMES[self.mon])
      self.strftime_nolocale(format)
    end
  END
end

require 'active_support'

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(:default => '%a %d %b %Y, %H:%M')
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(:default => '%a %d %b %Y', :long => '%A %d %B %Y')
