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
    assert_equal( 5, msg[:OBR].first.children.length )

    msg[:OBR].first.children.each do |x|
      assert_not_nil x
    end
  end

  def test_add_children
    msg = HL7::Message.new @base
    assert_not_nil msg
    assert_not_nil msg[:OBR]
    ob = HL7::Message::Segment::OBR.new
    assert_not_nil ob
    msg << ob
    assert_not_nil ob.children
    (1..4).each do |x|
      m = HL7::Message::Segment::OBX.new
      assert_not_nil m
      ob.children << m
    end
    assert_not_equal( @base, msg.to_hl7 )
  end
end

