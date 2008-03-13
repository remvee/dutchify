require 'ostruct'
require 'test_helper'

require 'rails/version'
require 'active_support'
require 'active_record'
require 'action_controller'
require 'action_controller/assertions/selector_assertions'
require 'action_view/helpers/text_helper'
require 'action_view/helpers/tag_helper'

require File.dirname(__FILE__) + '/../lib/active_record_helper'

class ActiveRecordHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::ActiveRecordHelper
  
  class RecordWithErrors
    attr_reader :errors
    def initialize(*errors)
      @errors = errors
      class << @errors
        def count; size; end
        def full_messages; self; end
      end
    end
  end
  
  class RecordWithErrorsAndHumanName < RecordWithErrors
    def self.human_name; 'RecordHumanName'; end
  end
  
  RecordWithoutErrors = RecordWithErrors
    
  def test_error_messages_for_should_render_one_error
    @person = RecordWithErrors.new 'fout'
    assert_equal %q{<div class="errorExplanation" id="errorExplanation"><h2>Vanwege 1 probleem kan person niet opgeslagen worden</h2><p>Er is een probleem met het volgende veld:</p><ul><li>fout</li></ul></div>},
        error_messages_for(:person)
  end
  
  def test_error_messages_for_should_render_one_error_from_two_objects
    @person = RecordWithErrors.new 'fout'
    @address = RecordWithoutErrors.new
    assert_equal %q{<div class="errorExplanation" id="errorExplanation"><h2>Vanwege 1 probleem kan person niet opgeslagen worden</h2><p>Er is een probleem met het volgende veld:</p><ul><li>fout</li></ul></div>},
        error_messages_for(:person, :address)
  end
  
  def test_error_messages_for_should_render_two_errors_from_one_object
    @person = RecordWithErrors.new 'fout1', 'fout2'
    assert_equal %q{<div class="errorExplanation" id="errorExplanation"><h2>Vanwege 2 problemen kan person niet opgeslagen worden</h2><p>Er zijn problemen met de volgende velden:</p><ul><li>fout1</li><li>fout2</li></ul></div>},
        error_messages_for(:person)
  end

  def test_error_messages_for_should_render_two_errors_from_two_objects
    @person = RecordWithErrors.new 'fout1'
    @address = RecordWithErrors.new 'fout2'
    assert_equal %q{<div class="errorExplanation" id="errorExplanation"><h2>Vanwege 2 problemen kan person niet opgeslagen worden</h2><p>Er zijn problemen met de volgende velden:</p><ul><li>fout1</li><li>fout2</li></ul></div>},
        error_messages_for(:person, :address)
  end
  
  def test_error_messages_for_should_render_object_name
    @person = RecordWithErrors.new 'fout'
    assert_equal %q{<div class="errorExplanation" id="errorExplanation"><h2>Vanwege 1 probleem kan persoon niet opgeslagen worden</h2><p>Er is een probleem met het volgende veld:</p><ul><li>fout</li></ul></div>},
        error_messages_for(:person, :object_name => 'persoon')
  end
  
  def test_error_messages_for_should_render_human_name
    @person = RecordWithErrorsAndHumanName.new('fout')
    
    assert_equal %q{<div class="errorExplanation" id="errorExplanation"><h2>Vanwege 1 probleem kan RecordHumanName niet opgeslagen worden</h2><p>Er is een probleem met het volgende veld:</p><ul><li>fout</li></ul></div>},
        error_messages_for(:person)
  end
  
  def test_error_messages_for_should_allow_nil
    assert error_messages_for(:some_nil).blank?
  end
  
  def test_error_messages_for_should_allow_multiple_nils
    assert error_messages_for(:some_nil, :some_other_nil).blank?
  end
end