require 'test_helper'
require File.dirname(__FILE__) + '/../lib/inflector'

class InflectorTest < Test::Unit::TestCase
  def test_ordinalize
    [
      [1, '1ste'], [2, '2de'], [3, '3de'], [8, '8ste'],
      [18, '18de'], [19, '19de'], [20, '20ste'], [21, '21ste'], [22, '22ste'],
      [100, '100ste'], [101, '101ste'], [102, '102de'], [108, '108ste'], [109, '109de'],
      [2310, '2310de'], [2311, '2311de'], [2320, '2320ste'], [2321, '2321ste'],
    ].each do |t|
      assert_equal t[1], t[0].ordinalize
    end

    [
      [1, '1st'], [2, '2nd'], [3, '3rd'], [4, '4th']
    ].each do |t|
      assert_equal t[1], Inflector.english_ordinalize(t[0])
    end
  end

  def test_underscore
    {
      "WijWillenIJs"                                 => "wij_willen_ijs",
      "WijWillenSoep"                                => "wij_willen_soep",
      "AuwSig9Gekregen"                              => "auw_sig9_gekregen",
      "FreeBSD"                                      => "free_bsd",
      "wij willen soep en ijsjes aan het IJsselmeer" => "wij_willen_soep_en_ijsjes_aan_het_ijsselmeer"
    }.each do |data,underscored|
      assert_equal underscored, data.underscore
    end
  end

  def test_titleize
    {
      "wij willen soep en ijsjes aan het IJsselmeer" => "Wij Willen Soep En IJsjes Aan Het IJsselmeer",
      "WijWillenSoepEnIJsjesAanHetIJsselmeer"        => "Wij Willen Soep En IJsjes Aan Het IJsselmeer",
      "MeerFreeBSDVoorIedereen"                      => "Meer Free Bsd Voor Iedereen",
      "GebruikIMAlleenStiekem"                       => "Gebruik Im Alleen Stiekem",
      "BahMJIsHelemaalNiets"                         => "Bah Mj Is Helemaal Niets"
    }.each do |data,titleized|
      assert_equal titleized, data.titleize
    end
  end

  def test_camelize
    {
      "la_die_da"                                    => "LaDieDa",
      "ijs_ijs_wij_willen_ijs"                       => "IJsIJsWijWillenIJs",
      "wij_willen_soep_en_ijsjes_aan_het_ijsselmeer" => "WijWillenSoepEnIJsjesAanHetIJsselmeer"
    }.each do |underscored,camelcase|
      assert_equal camelcase, underscored.camelize
      assert_equal underscored, camelcase.underscore
    end
  end

  def test_pluralize
    assert_equal "boompjes", "boompje".pluralize
    assert_equal "bomen", "boom".with_plural("bomen").pluralize

    assert_equal "boompje", "boompjes".singularize
    assert_equal "boom", "bomen".with_singular("boom").singularize

    assert_equal "boompje", "boompje".pluralize.singularize
    assert_equal "boompjes", "boompjes".singularize.pluralize
    assert_equal "boom", "boom".with_plural("bomen").pluralize.singularize
    assert_equal "bomen", "bomen".with_singular("boom").singularize.pluralize
  end
end
