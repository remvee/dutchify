require 'test_helper'
require File.dirname(__FILE__) + '/../lib/number_helper'

class NumberHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::NumberHelper
  include Math
  
  def test_number_to_currency
    assert_equal '&euro;3.999,99', number_to_currency(3_999.99)
    assert_equal 'EURO 3.999,99', number_to_currency(3_999.99, :unit => 'EURO ')
    assert_equal '&euro;999,99', number_to_currency(999.99)
    assert_equal '&euro;1999,99', number_to_currency(1_999.99, :delimiter => '')
    assert_equal '&euro;1.999!99', number_to_currency(1_999.99, :separator => '!')
    assert_equal '$3,999.99', english_number_to_currency(3_999.99)
    assert_equal 'EURO 3,999.99', english_number_to_currency(3_999.99, :unit => 'EURO ')
    assert_equal '$999.99', english_number_to_currency(999.99)
    assert_equal '$1999.99', english_number_to_currency(1_999.99, :delimiter => '')
    assert_equal '$1,999!99', english_number_to_currency(1_999.99, :separator => '!')
  end

  def test_human_size
    assert_equal '1,2 KB', human_size(1234)
    assert_equal '1,2 KB', number_to_human_size(1234)
    assert_equal '1,2 KB', dutch_number_to_human_size(1234)
    assert_equal '1.2 KB', english_human_size(1234)
    assert_equal '1.2 KB', english_number_to_human_size(1234)
  end

  def test_number_to_percentage
    assert_equal '3,142%', number_to_percentage(PI)
    assert_equal '3!142%', number_to_percentage(PI, :separator => '!')
    assert_equal '3!14%', number_to_percentage(PI, :separator => '!', :precision => 2)
    assert_equal '3,142%', dutch_number_to_percentage(PI)
    assert_equal '3!142%', dutch_number_to_percentage(PI, :separator => '!')
    assert_equal '3!14%', dutch_number_to_percentage(PI, :separator => '!', :precision => 2)
    assert_equal '3.142%', english_number_to_percentage(PI)
    assert_equal '3!142%', english_number_to_percentage(PI, :separator => '!')
    assert_equal '3!14%', english_number_to_percentage(PI, :separator => '!', :precision => 2)
  end

  def test_number_with_delimiter
    assert_equal '1.000.000', number_with_delimiter(1_000_000)
    assert_equal '1.000.000,0', dutch_number_with_delimiter(1_000_000.0)
    assert_equal '1x000x000y0', number_with_delimiter(1_000_000.0, 'x', 'y')
    
    assert_equal '1.000.000', dutch_number_with_delimiter(1_000_000)
    assert_equal '1.000.000,0', dutch_number_with_delimiter(1_000_000.0)
    
    assert_equal '1,000,000', english_number_with_delimiter(1_000_000)
    assert_equal '1,000,000.0', english_number_with_delimiter(1_000_000.0)
  end
end
