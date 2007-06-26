# $Id$
$: << '../lib'
require 'test/unit'
require 'ruby-hl7'

class ChildSegment < Test::Unit::TestCase
  def setup
    @base = open( './test_data/obxobr.hl7' ).readlines
  end

  def test_access_children
    msg = HL7::Message.new @base
    assert_not_nil msg
    assert_not_nil msg[:OBR]
    assert_equal( 3, msg[:OBR].length ) 
    assert_not_nil msg[:OBR].first.children

    msg[:OBR].first.children.each do |x|
      assert_not_nil x
    end

  end
end

