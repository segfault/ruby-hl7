# $Id$
$: << '../lib'
require 'test/unit'
require 'ruby-hl7'

class BasicParsing < Test::Unit::TestCase
  def setup
    @simple_msh_txt = open( './test_data/test.hl7' ).readlines.first
    @empty_txt = open( './test_data/empty.hl7' ).readlines.first
    @empty_segments_txt = open( './test_data/empty_segments.hl7' ).readlines.first
    @base_msh = "MSH|^~\\&|LAB1||DESTINATION||19910127105114||ORU^R03|LAB1003929"
    @base_msh_alt_delims = "MSH$@~\\&|LAB1||DESTINATION||19910127105114||ORU^R03|LAB1003929"
  end

  def test_simple_msh
    msg = HL7::Message.new
    msg.parse @simple_msh_txt
    assert_equal( @simple_msh_txt, msg.to_hl7 )
  end
  
  def test_parse_delims
    msg = HL7::Message.new( @base_msh )
    assert_equal( "|", msg.element_delim )
    assert_equal( "^", msg.item_delim )
    
    msg = HL7::Message.new( @base_msh_alt_delims )
    assert_equal( "$", msg.element_delim )
    assert_equal( "@", msg.item_delim )
  end

  def test_constructor_parse
    msg = HL7::Message.new( @simple_msh_txt )
    assert_equal( @simple_msh_txt, msg.to_hl7 )
  end

  def test_class_parse
    msg = HL7::Message.parse( @simple_msh_txt )
    assert_equal( @simple_msh_txt, msg.to_hl7 )
  end

  def test_not_string_or_enumerable
    assert_raise( HL7::ParseError ) do
      msg = HL7::Message.parse( :MSHthis_shouldnt_parse_at_all )
    end
  end

  def test_parse_empty
    msg = HL7::Message.new @empty_txt
  end

  def test_message_to_string
    msg = HL7::Message.new
    msg.parse @simple_msh_txt
    orig = @simple_msh_txt.gsub( /\r/, "\n" )
    assert_equal( orig, msg.to_s )
  end

  def test_to_s_vs_to_hl7
    msg = HL7::Message.new( @simple_msh_txt )
    assert_not_equal( msg.to_s, msg.to_hl7 )
  end

  def test_segment_numeric_accessor
    msg = HL7::Message.new
    msg.parse @simple_msh_txt
    assert_equal( @base_msh, msg[0].to_s ) 
  end

  def test_segment_string_accessor
    msg = HL7::Message.new
    msg.parse @simple_msh_txt
    assert_equal( @base_msh, msg["MSH"].to_s ) 
  end

  def test_segment_symbol_accessor
    msg = HL7::Message.new
    msg.parse @simple_msh_txt
    assert_equal( @base_msh, msg[:MSH].to_s ) 
  end

  def test_segment_numeric_mutator
    msg = HL7::Message.new
    msg.parse @simple_msh_txt
    inp = HL7::Message::Segment::Default.new
    msg[1] = inp
    assert_equal( inp, msg[1] )

    assert_raise( HL7::Exception ) do
      msg[2] = Class.new
    end
  end

  def test_segment_missing_accessor
    msg = HL7::Message.new
    msg.parse @simple_msh_txt
    assert_nothing_raised do
      assert_equal( nil, msg[:does_not_exist] )
    end
  end

  def test_segment_string_mutator
    msg = HL7::Message.new
    msg.parse @simple_msh_txt
    inp = HL7::Message::Segment::NTE.new
    msg["NTE"] = inp
    assert_equal( inp, msg["NTE"] )

    assert_raise( HL7::Exception ) do
      msg["NTE"] = Class.new
    end
  end

  def test_segment_symbol_accessor
    msg = HL7::Message.new
    msg.parse @simple_msh_txt
    inp = HL7::Message::Segment::NTE.new
    msg[:NTE] = inp
    assert_equal( inp, msg[:NTE] )

    assert_raise( HL7::Exception ) do
      msg[:NTE] = Class.new
    end
  end

  def test_element_accessor
    msg = HL7::Message.new
    msg.parse @simple_msh_txt
    assert_equal( "LAB1", msg[:MSH].sending_app )
  end

  def test_element_mutator
    msg = HL7::Message.new
    msg.parse @simple_msh_txt
    msg[:MSH].sending_app = "TEST"
    assert_equal( "TEST", msg[:MSH].sending_app )
  end

  def test_element_missing_accessor
    msg = HL7::Message.new
    msg.parse @simple_msh_txt
    assert_raise( HL7::Exception, NoMethodError ) do
      msg[:MSH].does_not_really_exist_here
    end
  end

  def test_element_missing_mutator
    msg = HL7::Message.new
    msg.parse @simple_msh_txt
    assert_raise( HL7::Exception, NoMethodError ) do
      msg[:MSH].does_not_really_exist_here = "TEST"
    end
  end

  def test_element_numeric_accessor
    msg = HL7::Message.new( @simple_msh_txt )
    
    assert_equal( "LAB1", msg[:MSH].e2 ) 
    assert_equal( "", msg[:MSH].e3 )
  end

  def test_element_numeric_mutator
    msg = HL7::Message.parse( @simple_msh_txt )
    msg[:MSH].e2 = "TESTING1234"
    assert_equal( "TESTING1234", msg[:MSH].e2 )
  end

  def test_segment_append
    msg = HL7::Message.new
    assert_nothing_raised do
      msg << HL7::Message::Segment::MSH.new
      msg << HL7::Message::Segment::NTE.new
    end

    assert_raises( HL7::Exception ) do
      msg << Class.new
    end
  end


  def test_segment_sort
    msg = HL7::Message.new
    pv1 = HL7::Message::Segment::PV1.new
    msg << pv1
    msh = HL7::Message::Segment::MSH.new
    msg << msh
    nte = HL7::Message::Segment::NTE.new
    msg << nte
    nte2 = HL7::Message::Segment::NTE.new
    msg << nte
    msh.sending_app = "TEST"
    

    initial = msg.to_s
    sorted = msg.sort
    final = sorted.to_s
    assert_not_equal( initial, final )
  end

  def test_segment_auto_set_id
    msg = HL7::Message.new
    msh = HL7::Message::Segment::MSH.new
    msg << msh
    ntea = HL7::Message::Segment::NTE.new
    ntea.comment = "first"
    msg << ntea
    nteb = HL7::Message::Segment::NTE.new
    nteb.comment = "second"
    msg << nteb
    ntec = HL7::Message::Segment::NTE.new
    ntec.comment = "third"
    msg << ntec
    assert_equal( "1", ntea.set_id )
    assert_equal( "2", nteb.set_id )
    assert_equal( "3", ntec.set_id )
  end

  def test_enumerable_parsing
    test_file = open( './test_data/test.hl7' )
    assert_not_nil( test_file )

    msg = HL7::Message.new( test_file )
    assert_equal( @simple_msh_txt, msg.to_hl7 )
  end

  def test_segment_to_info
    msg = HL7::Message.new( @simple_msh_txt )
    assert_not_nil( msg[1].to_info )
  end

  def test_segment_use_raw_array
    inp = "NTE|1|ME TOO"
    nte = HL7::Message::Segment::NTE.new( inp.split( '|' ) )
    assert_equal( inp, nte.to_s )
  end

  def test_mllp_output
    msg = HL7::Message.new( @simple_msh_txt )
    expect = "\x0b%s\x1c\r" % msg.to_hl7
    assert_equal( expect, msg.to_mllp )
  end

  def test_parse_mllp
    raw = "\x0b%s\x1c\r" % @simple_msh_txt
    msg = HL7::Message.parse( raw )
    assert_not_nil( msg )
    assert_equal( @simple_msh_txt, msg.to_hl7 )
    assert_equal( raw, msg.to_mllp )
  end

  def test_mllp_output_parse
    msg = HL7::Message.parse( @simple_msh_txt )
    assert_not_nil( msg )
    assert_nothing_raised do
      post_mllp = HL7::Message.parse( msg.to_mllp )
      assert_not_nil( post_mllp )
      assert_equal( msg.to_hl7, post_mllp.to_hl7 )
    end
  end

  def test_child_segment_accessor
    obr = HL7::Message::Segment::OBR.new
    assert_nothing_raised do
      assert_not_nil( obr.children )
      assert_equal( 0, obr.children.length )
    end
  end

  def test_child_segment_addition
    obr = HL7::Message::Segment::OBR.new
    assert_nothing_raised do
      assert_equal( 0, obr.children.length )
      (1..5).each do |x|
        obr.children << HL7::Message::Segment::OBX.new
        assert_equal( x, obr.children.length )
      end
    end
  end

  def test_child_segment_invalid_addition
    obr = HL7::Message::Segment::OBR.new
    assert_raises(HL7::Exception) do
      obr.children << Class.new
    end
  end

  def test_grouped_sequenced_segments
    #multible obr's with multiple obx's
    msg = HL7::Message.parse( @simple_msh_txt )
    orig_output = msg.to_hl7
    orig_obx_cnt = msg[:OBX].length
    (1..10).each do |obr_id|
      obr = HL7::Message::Segment::OBR.new
      msg << obr
      (1..10).each do |obx_id|
        obx = HL7::Message::Segment::OBX.new
        obr.children << obx
      end
    end

    assert_not_nil( msg[:OBR] )
    assert_equal( 11, msg[:OBR].length )
    assert_not_nil( msg[:OBX] )
    assert_equal( 102, msg[:OBX].length ) 
    assert_equal( "2", msg[:OBR][4].children[1].set_id ) # confirm the id's
    assert_equal( "2", msg[:OBR][5].children[1].set_id ) # confirm the id's

    final_output = msg.to_hl7
    assert_not_equal( orig_output, final_output )
  end

  def test_index_accessor
    msg = HL7::Message.parse( @simple_msh_txt )
    assert_equal( 1, msg.index( "PID" ) )
    assert_equal( 1, msg.index( :PID ) )
    assert_equal( 2, msg.index( "PV1" ) )
    assert_equal( 2, msg.index( :PV1 ) )
    assert_equal( nil, msg.index( "TACOBELL" ) )
    assert_equal( nil, msg.index( nil ) )
    assert_equal( nil, msg.index( 1 ) )
  end

  def test_segment_field_block
    pid = HL7::Message::Segment::PID.new
    assert_raises( HL7::InvalidDataError ) do
      pid.admin_sex = "TEST"
    end
    assert_nothing_raised do
      pid.admin_sex = "F"
    end
  end

  def test_empty_segment
    msg = HL7::Message.new @empty_segments_txt

  end

end
