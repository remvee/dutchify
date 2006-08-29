#!/usr/bin/env ruby

require 'test/unit'
require File.dirname(__FILE__) + '/../lib/date_helper'

class DateHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::DateHelper
  
  def test_distance_of_time_in_words
    now = Time.now.to_i
    assert_equal "1 minuut", distance_of_time_in_words(60)
    assert_equal "1 minuut", distance_of_time_in_words(now, now + 60)
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
  end
end
