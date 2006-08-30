%w{active_record date_time date_helper dutch_names stijgers with_plural inflector number_helper}.each do |mod|
  require File.join(File.dirname(__FILE__), mod)
end
