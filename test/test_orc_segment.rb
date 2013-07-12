# encoding: UTF-8
$: << '../lib'
require 'test/unit'
require 'ruby-hl7'

class OrcSegment < Test::Unit::TestCase
  def setup
    @base = "ORC|RE|HOSP333444|ZZ13-886644|CM||||20130620090252|20130620091418000|||1639330756^Haston^W^^^^^^^^^^NPI|10114A1|||||||||||"
  end

  def test_read
    orc = HL7::Message::Segment::ORC.new @base
    assert_equal( @base, orc.to_s )
    assert_equal( "RE", orc.e1 )
    assert_equal( "RE", orc.order_control)
    assert_equal( "HOSP333444", orc.placer_order_number )
    assert_equal( "ZZ13-886644", orc.filler_order_number )
    assert_equal( "1639330756^Haston^W^^^^^^^^^^NPI", orc.ordering_phys)
  end

  def test_create
    orc = HL7::Message::Segment::ORC.new
    orc.order_control = "RE"
    assert_equal( "RE", orc.order_control)
    orc.placer_order_number = "HOSP333444" 
    assert_equal( "HOSP333444", orc.placer_order_number )
    orc.filler_order_number= "ZZ13-886644" 
    assert_equal( "ZZ13-886644", orc.filler_order_number )
    orc.ordering_phys= "1639330756^Haston^W^^^^^^^^^^NPI" 
    assert_equal( "1639330756^Haston^W^^^^^^^^^^NPI", orc.ordering_phys)
    orc.placer_order_number = "^DMCRES"
    assert_equal( "^DMCRES", orc.placer_order_number )
  end

end
