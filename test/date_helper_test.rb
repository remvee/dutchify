#!/usr/bin/env ruby

require 'test/unit'
require File.dirname(__FILE__) + '/../lib/date_helper'

class DateHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::DateHelper
  
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
  end
end
