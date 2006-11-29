require 'test_helper'
require File.dirname(__FILE__) + '/../lib/array_extensions'

class ArrayExtensionTest < Test::Unit::TestCase
  def test_time_to_sentence
    assert_equal "", [].to_sentence
    assert_equal "foo", %w(foo).to_sentence
    assert_equal "foo en bar", %w(foo bar).to_sentence
    assert_equal "foo, bar en baz", %w(foo bar baz).to_sentence
    assert_equal "foo, bar of baz", %w(foo bar baz).to_sentence(:connector => 'of')
    assert_equal "foo, bar, ene baz", %w(foo bar baz).to_sentence(:connector => 'ene', :skip_last_comma => false)
    assert_equal "foo, bar, en baz", %w(foo bar baz).to_sentence(:skip_last_comma => false)
  end
end
