# $Id$
$: << '../lib'
require 'test/unit'
require 'ruby-hl7'

class MsaSegment < Test::Unit::TestCase
  def setup
    @base_msa = "MSA|AR|ZZ9380 ERR"
  end

  def test_storing_existing_segment
    seg = HL7::Message::Segment::Default.new( @base_msa )
    assert_equal( @base_msa, seg.to_s )
  end

  def test_to_s
    seg = HL7::Message::Segment::Default.new( @base_msa )
    assert_equal( @base_msa, seg.to_s )
    assert_equal( seg.to_s, seg.to_hl7 )
  end

  def test_create_raw_segment
    seg = HL7::Message::Segment::Default.new
    seg.e0 = "NK1"
    seg.e1 = "INFO"
    seg.e2 = "MORE INFO"
    seg.e5 = "LAST INFO"
    assert_equal( "NK1|INFO|MORE INFO|||LAST INFO", seg.to_s )
  end

end
