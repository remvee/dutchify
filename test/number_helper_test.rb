#!/usr/bin/env ruby

require 'test/unit'
require File.dirname(__FILE__) + '/../lib/number_helper'

class NumberHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::NumberHelper
  
  def test_number_to_currency
    assert_equal '&euro;3.999,99', number_to_currency(3_999.99)
    assert_equal 'EURO 3.999,99', number_to_currency(3_999.99, :unit => 'EURO ')
    assert_equal '&euro;999,99', number_to_currency(999.99)
    assert_equal '&euro;1999,99', number_to_currency(1_999.99, :delimiter => '')
    assert_equal '&euro;1.999!99', number_to_currency(1_999.99, :separator => '!')
  end

  def test_english_number_to_currency
    assert_equal '$3,999.99', english_number_to_currency(3_999.99)
    assert_equal 'EURO 3,999.99', english_number_to_currency(3_999.99, :unit => 'EURO ')
    assert_equal '$999.99', english_number_to_currency(999.99)
    assert_equal '$1999.99', english_number_to_currency(1_999.99, :delimiter => '')
    assert_equal '$1,999!99', english_number_to_currency(1_999.99, :separator => '!')
  end
end
