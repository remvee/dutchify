Dir[File.join(File.dirname(__FILE__), "lib", "*.rb")].each do |fname|
  require fname
end
