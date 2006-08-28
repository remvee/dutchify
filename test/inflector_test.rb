#!/usr/bin/env ruby

require 'test/unit'
require 'inflector'

class InflectorTest < Test::Unit::TestCase
  include Inflector
  
  def test_ordinalize
    [
      [1, '1ste'], [2, '2de'], [3, '3de'], [8, '8ste'],
      [18, '18de'], [19, '19de'], [20, '20ste'], [21, '21ste'], [22, '22ste'],
      [100, '100ste'], [101, '101ste'], [102, '102de'], [108, '108ste'], [109, '109de'],
      [2310, '2310de'], [2311, '2311de'], [2320, '2320ste'], [2321, '2321ste'],
    ].each do |t|
      assert_equal t[1], ordinalize(t[0])
    end
  end
end
