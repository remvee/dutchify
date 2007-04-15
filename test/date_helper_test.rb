require 'test_helper'
require 'rails/version'
require 'active_support'
require 'action_view/helpers/date_helper'
require 'action_view/helpers/form_helper'
require File.dirname(__FILE__) + '/../lib/date_time'
require File.dirname(__FILE__) + '/../lib/date_helper'

class DateHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::FormHelper
  
  def test_time_ago_in_words
    now = Time.now.to_i
    assert_equal "1 minuut", distance_of_time_in_words(60)
    assert_equal "1 minuut", distance_of_time_in_words(now, now + 60)
    assert_equal "1 minuut", time_ago_in_words(Time.now - 60)
    assert_equal "1 minuut", distance_of_time_in_words_to_now(Time.now - 60)
    assert_equal "minder dan een minuut", distance_of_time_in_words(50)
    assert_equal "minder dan een minuut", distance_of_time_in_words(50, 0, true)
    assert_equal "minder dan een minuut", distance_of_time_in_words(30, 0, false)
    assert_equal "een halve minuut", distance_of_time_in_words(30, 0, true)
    assert_equal "5 minuten", distance_of_time_in_words(60 * 5)
    assert_equal "ongeveer 1 uur", distance_of_time_in_words(60 * 55)
    assert_equal "ongeveer 1 uur", distance_of_time_in_words(60 * 75)
    assert_equal "ongeveer 6 uur", distance_of_time_in_words(60 * 60 * 6)
    assert_equal "1 dag", distance_of_time_in_words(60 * 60 * 25)
    assert_equal "23 dagen", distance_of_time_in_words(60 * 60 * 24 * 23)
    assert_equal "ongeveer 1 maand", distance_of_time_in_words(60 * 60 * 24 * 31)
    assert_equal "ongeveer 1 maand", distance_of_time_in_words(60 * 60 * 24 * 30)
    assert_equal "ongeveer 1 maand", distance_of_time_in_words(60 * 60 * 24 * 59)
    assert_equal "8 maanden", distance_of_time_in_words(60 * 60 * 24 * 31 * 8)
    assert_equal "ongeveer 1 jaar", distance_of_time_in_words(60 * 60 * 24 * 31 * 12)
    assert_equal "meer dan 4 jaar", distance_of_time_in_words(60 * 60 * 24 * 31 * 12 * 4)
  end

  def test_english_time_ago_in_words
    now = Time.now.to_i
    assert_equal "1 minute", english_distance_of_time_in_words(60)
    assert_equal "1 minute", english_distance_of_time_in_words(now, now + 60)
    assert_equal "1 minute", english_time_ago_in_words(Time.now - 60)
    assert_equal "1 minute", english_distance_of_time_in_words_to_now(Time.now - 60)
    assert_equal "less than a minute", english_distance_of_time_in_words(50)
    assert_equal "less than a minute", english_distance_of_time_in_words(50, 0, true)
    assert_equal "less than a minute", english_distance_of_time_in_words(30, 0, false)
    assert_equal "half a minute", english_distance_of_time_in_words(30, 0, true)
    assert_equal "5 minutes", english_distance_of_time_in_words(60 * 5)
    assert_equal "about 1 hour", english_distance_of_time_in_words(60 * 55)
    assert_equal "about 1 hour", english_distance_of_time_in_words(60 * 75)
    assert_equal "about 6 hours", english_distance_of_time_in_words(60 * 60 * 6)
    assert_equal "1 day", english_distance_of_time_in_words(60 * 60 * 25)
    assert_equal "23 days", english_distance_of_time_in_words(60 * 60 * 24 * 23)

    if Rails::VERSION::MAJOR > 1 || Rails::VERSION::MINOR > 1 # since rails-1.2
      assert_equal "about 1 month", english_distance_of_time_in_words(60 * 60 * 24 * 31)
      assert_equal "about 1 month", english_distance_of_time_in_words(60 * 60 * 24 * 30)
      assert_equal "about 1 month", english_distance_of_time_in_words(60 * 60 * 24 * 59)
      assert_equal "8 months", english_distance_of_time_in_words(60 * 60 * 24 * 31 * 8)
      assert_equal "about 1 year", english_distance_of_time_in_words(60 * 60 * 24 * 31 * 12)
      assert_equal "over 4 years", english_distance_of_time_in_words(60 * 60 * 24 * 31 * 12 * 4)
    end
  end
  
  def test_selects_should_contain_maart_and_mei
    [datetime_select(:foo, :bar), date_select(:foo, :bar), select_date, select_datetime, select_month(Date.today)].each do |t|
      assert_match /\bmaart\b.*\bmei\b/m, t
    end
  end
end
