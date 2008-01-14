require 'test_helper'
require File.dirname(__FILE__) + '/../lib/date_time'
require 'time'

class DateTimeTest < Test::Unit::TestCase
  def test_strftime_weekday_monthname
    assert_equal 'za zaterdag mei mei', Time.mktime(2007, 5, 5).strftime("%a %A %b %B")
    assert_equal 'ma maandag maa maart', Time.mktime(2007, 3, 5).strftime("%a %A %b %B")
  end
  
  def test_back_and_forth
    t = Time.now
    assert_equal t.to_s, Time.parse(t.to_s).to_s
  end
  
  def test_parse
    assert_equal Time.mktime(2007, 4, 9, 16, 21), Time.parse("ma 09 apr 2007, 16:21")
  end
  
  def test_time_to_s
    assert_equal 'do 10 mei 2007, 16:33', Time.mktime(2007, 5, 10, 16, 33).to_s
  end
  
  def test_date_to_s
    assert_equal 'do 10 mei 2007', Date.civil(2007, 5, 10).to_s
  end
  
  def test_datetime_to_s
    assert_match /^do 10 mei 2007/, DateTime.civil(2007, 5, 10).to_s
  end
end
