require 'ostruct'
require 'test_helper'
require 'rails/version'
require 'active_support'
require 'active_record'
# require 'action_view/helpers/date_helper'
# require 'action_view/helpers/form_helper'
require File.dirname(__FILE__) + '/../lib/active_record_helper'

class ActiveRecordHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::ActiveRecordHelper
  
  def test_error_messages_for_should_render_two_errors
    @person = OpenStruct.new(:errors => OpenStruct.new(:size => 2, :full_messages => ['fout1', 'fout2']))
    assert_match /fout1/, error_messages_for(:person)
    assert_match /fout2/, error_messages_for(:person)
  end
  
  def test_error_messages_for_should_allow_nil
    @some_nil_value = nil
    assert_nil error_messages_for(:some_nil_value)
  end
  
private
  def content_tag(name, content, options = {})
    "<#{name} #{options.map{|k,v|"#{k}=#{v.inspect}"}.join(' ')}>#{content}</#{name}>"
  end
end