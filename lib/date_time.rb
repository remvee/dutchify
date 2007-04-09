DutchifyDateFormat = RUBY_VERSION >= "1.8.6" ? Date::Format : Date
  
DutchifyDateFormat::MONTHNAMES = [nil] + %w{januari februari maart april mei juni juli augustus september oktober november december}
DutchifyDateFormat::MONTHS = {}
DutchifyDateFormat::MONTHNAMES.each_with_index { |v,i| DutchifyDateFormat::MONTHS[v] = i if v }

DutchifyDateFormat::ABBR_MONTHNAMES = [nil] + %w{jan feb maa apr mei jun jul aug sep okt nov dec}
DutchifyDateFormat::ABBR_MONTHS = {}
DutchifyDateFormat::ABBR_MONTHNAMES.each_with_index { |v,i| DutchifyDateFormat::ABBR_MONTHS[v] = i if v }

DutchifyDateFormat::DAYNAMES = %w{zondag maandag dinsdag woensdag donderdag vrijdag zaterdag}
DutchifyDateFormat::DAYS = {}
DutchifyDateFormat::DAYNAMES.each_with_index { |v,i| DutchifyDateFormat::DAYS[v] = i }

DutchifyDateFormat::ABBR_DAYNAMES = %w{zo ma di wo do vr za}
DutchifyDateFormat::ABBR_DAYS = {}
DutchifyDateFormat::ABBR_DAYNAMES.each_with_index { |v,i| DutchifyDateFormat::ABBR_DAYS[v] = i }

class Time # :nodoc:
  alias :strftime_nolocale :strftime
  def strftime(format)
    format = format.dup
    format.gsub!(/%a/, DutchifyDateFormat::ABBR_DAYNAMES[self.wday])
    format.gsub!(/%A/, DutchifyDateFormat::DAYNAMES[self.wday])
    format.gsub!(/%b/, DutchifyDateFormat::ABBR_MONTHNAMES[self.mon])
    format.gsub!(/%B/, DutchifyDateFormat::MONTHNAMES[self.mon])
    self.strftime_nolocale(format)
  end
end

require 'active_support'

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(:default => '%a %d %b %Y, %H:%M')
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(:default => '%a %d %b %Y', :long => '%A %d %B %Y')
