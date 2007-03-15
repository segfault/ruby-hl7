# $Id$
$: << '../lib'
require 'test/unit'
require 'ruby-hl7'

class MsaSegment < Test::Unit::TestCase
  def setup
    @base_msa = "MSA|AR|ZZ9380 ERR"
  end

  def test_create_msa
    assert_nothing_raised do
      msa = HL7::Message::Segment::MSA.new( @base_msa )
      assert_not_nil( msa )
      assert_equal( @base_msa, msa.to_s )
    end
  end

  def test_access_msa
    assert_nothing_raised do
      msa = HL7::Message::Segment::MSA.new( @base_msa )
      assert_equal( "AR", msa.ack_code )
      assert_equal( "ZZ9380 ERR", msa.control_id )
    end
  end

end
