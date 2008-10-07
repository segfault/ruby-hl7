# $Id$
$: << '../lib'
require 'test/unit'
require 'ruby-hl7'

class ObrSegment < Test::Unit::TestCase
  def setup
    @base = "OBR|2|^USSSA|0000000567^USSSA|37956^CT ABDOMEN^LN|||199405021550|||||||||||||0000763|||||P||||||R/O TUMOR|202300&BAKER&MARK&E|||01&LOCHLEAR&JUDY"
  end

  def test_read
    obr = HL7::Message::Segment::OBR.new @base
    assert_equal( @base, obr.to_s )
    assert_equal( "2", obr.e1 )
    assert_equal( "2", obr.set_id )
    assert_equal( "^USSSA", obr.placer_order_number )
    assert_equal( "0000000567^USSSA", obr.filler_order_number )
    assert_equal( "37956^CT ABDOMEN^LN", obr.universal_service_id )
  end

  def test_create
    obr = HL7::Message::Segment::OBR.new
    obr.set_id = 1
    assert_equal( "1", obr.set_id ) 
    obr.placer_order_number = "^DMCRES"
    assert_equal( "^DMCRES", obr.placer_order_number )
  end

end
