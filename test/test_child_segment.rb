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
    assert_not_nil ob.segment_parent
    assert_equal(msg, ob.segment_parent)
    orig_cnt = msg.length
    
    (1..4).each do |x|
      m = HL7::Message::Segment::OBX.new
      m.observation_value = "taco"
      assert_not_nil m
      assert_not_nil /taco/.match( m.to_s )
      ob.children << m
      assert_equal(x, ob.children.length)
      assert_not_nil m.segment_parent
      assert_equal(ob, m.segment_parent)
    end
    
    assert_not_equal( @base, msg.to_hl7 )
    assert_not_equal( orig_cnt, msg.length )
    text_ver = msg.to_hl7
    assert_not_nil /taco/.match( text_ver )
  end
end

