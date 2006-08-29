%w{active_record date_time date_helper dutch_names stijgers with_plural inflector}.each do |mod|
  require File.join(File.dirname(__FILE__), mod)
end
