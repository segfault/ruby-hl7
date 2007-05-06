# $Id$
$: << '../lib'
require 'test/unit'
require 'ruby-hl7'

class PidSegment < Test::Unit::TestCase
  def setup
    @base = "PID|||333||LastName^FirstName^MiddleInitial^SR^NickName||19760228|F||||||||||555. 55|012345678"
  end

  def test_admin_sex_limits
    pid = HL7::Message::Segment::PID.new
    assert_nothing_raised do
      vals = %w[F M O U A N] + [ nil ]
      vals.each do |x|
        pid.admin_sex = x
      end
      pid.admin_sex = ""
    end

    assert_raises( HL7::InvalidDataError ) do
      ["TEST", "A", 1, 2].each do |x|
        pid.admin_sex = x
      end
    end
        
  end
end
