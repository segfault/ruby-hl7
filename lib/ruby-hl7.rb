# $Id$
# {{{ Copyright Notice
# Copyright (c) 2006 Mark Guzman
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# }}} Copyright Notice

# {{{ ri info
#= ruby-hl7.rb
#
# Ruby HL7 is designed to provide a simple, easy to use library for
# parsing and generating HL7 (2.x) messages.
#
#== Example
# }}} ri info

require 'rubygems'
require "stringio"
require "date"
require 'facets/core/class/cattr'

module HL7
end

class HL7::Exception < StandardError
end

class HL7::ParseError < HL7::Exception
end

class HL7::RangeError < HL7::Exception
end

class HL7::Message
  include Enumerable # we treat an hl7 2.x message as a collection of segments
  attr :element_delim
  attr :item_delim
  attr :segment_delim

  def initialize
    @segments = []
    @segments_by_name = {}
    @item_delim = "^"
    @element_delim = '|' 
    @segment_delim = "\r"
  end

  def []( index )
    ret = nil
    #puts "calling [%s]" % index

    if index.kind_of?(Range) || index.kind_of?(Fixnum)
      ret = @segments[ index ]
    elsif (index.respond_to? :to_sym)
      ret = @segments_by_name[ index.to_sym ]
      ret = ret.first if ret.length == 1
    end

    ret
  end

  def []=( index, value )
    if index.kind_of?(Range) || index.kind_of?(Fixnum)
      @segments[ index ] = value
    else
      (@segments_by_name[ index.to_sym ] ||= []) << value
    end
  end

  def <<( value )
    #raise HL7::Exception.new( "invalid argument to <<" ) if value.kind_of?(HL7::Message::Segment)
    (@segments ||= []) << value
    name = value.class.to_s.gsub("HL7::Message::Segment::", "").to_sym
    (@segments_by_name[ name ] ||= []) << value
  end

  def self.parse( inobj )
    #puts "here"
    ret = HL7::Message.new
    ret.parse( inobj )
    ret
  end

  def parse( inobj )
    unless inobj.kind_of?(String) || inobj.respond_to?(:each)
      raise HL7::ParseError.new
    end

    #puts "kls: " + inobj.class.to_s
    if inobj.kind_of?(String)
        parse_string( inobj )
    elsif inobj.respond_to?(:each)
        parse_enumerable( inobj )
    end

    #puts "done"
  end

  def each
    return unless @segments
    @segments.each { |s| yield s }
  end

  def to_s    
    @segments.join( '\n' )
  end

  def to_hl7
    @segments.join( @segment_delim )
  end

  def to_mllp
  end

  private
  def parse_enumerable( inary )
    #puts "parsing enumerable"
    oary = inary.join( "" )
    parse_string( oary )
    #inary.each do |elm|
    #    s
    #end
  end

  def parse_string( instr )
    #puts "parsing string"
    ary = instr.split( segment_delim, -1 )
    generate_segments( ary )
  end

  def generate_segments( ary )
    #puts "generate_segments"
    raise HL7::ParseError.new unless ary.length > 0
    #puts "ary.length: %d" % ary.length

    ary.each do |elm|
      #puts "elm: %s" % elm
      #puts "element delim: %s" % @element_delim
      seg_parts = elm.split( @element_delim, -1 )
      raise HL7::ParseError.new unless seg_parts && (seg_parts.length > 0)
      #puts "seg parts: %s" % seg_parts.length

      #raise HL7::ParseError.new unless HL7::Message::Segment.constants.index( seg_parts[0] )

      seg_name = seg_parts[0]
      begin
        kls = eval("HL7::Message::Segment::%s" % seg_name)
      rescue Exception
        # we don't have an implementation for this segment
        # so lets just preserve the data
        #puts "error: %s" % $!
        kls = HL7::Message::Segment::Default
      end
      new_seg = kls.new elm

      #puts "seg_parts[0]: %s" % seg_parts[0]
      @segments << new_seg

      # we want to allow segment lookup by name
      seg_sym = seg_name.to_sym
      @segments_by_name[ seg_sym ] ||= []
      @segments_by_name[ seg_sym ] << new_seg
    end

  end
end                

class HL7::Message::Segment
  attr :element_delim
  attr :item_delim
  attr :segment_weight

  def initialize(raw_segment="")
    @segments_by_name = {}
    @element_delim = '|'
    @field_total = 0

    if (raw_segment != nil && raw_segment != "")
      if (raw_segment.kind_of? Array)
        @elements = raw_segment
      else
        @elements = raw_segment.split( element_delim, -1 )
      end
    else
      (@elements ||= []) << self.class.to_s.split( ':' ).last
      @elements << ""
    end
    #puts "element count: %d" % @elements.length
    
  end

  def to_info
    "%s: empty segment >> %s" % [ self.class.to_s, @elements.inspect ] 
  end

  def to_s
    @elements.join( @element_delim )
  end

  def method_missing( sym, *args, &blk )
    base_str = sym.to_s.gsub( "=", "" )
    base_sym = base_str.to_sym

    if self.class.field_ids.include?( base_sym )
      if sym.to_s.include?( "=" )
        write_field( base_sym, args )
      else
        read_field( base_sym )
      end 
    else
      super.method_missing( sym, args, blk )  
    end
  end

  def <=>( other )
    #return nil if other.kind_of?(HL7::Message::Segment)
    diff = self.weight - other.weight
    return 1 if diff > 0
    return -1 if diff < 0
    return 0
  end
  
  def weight
    self.class.weight
  end

  private
  def self.singleton
    class << self; self end
  end

  def self.segment_weight( my_weight )
    singleton.module_eval do
      @my_weight = my_weight
    end
  end

  def self.weight
    singleton.module_eval do
      return 999 unless @my_weight
      @my_weight
    end
  end

  def self.add_field( options={} )
    options = {:name => :id, :idx =>0}.merge!( options )
    name = options[:name]
    namesym = name.to_sym
    
    singleton.module_eval do
      @field_ids ||= {}
      #puts @field_ids
      @field_ids[ namesym ] = options[:idx].to_i - 1 
    end
    eval <<-END
      def #{name}()
        read_field( :#{namesym} )
      end

      def #{name}=(value)
        write_field( :#{namesym}, value ) 
      end
    END

  end

  def self.field_ids
    singleton.module_eval do
      @field_ids
    end
  end

  def read_field( name )
    idx = self.class.field_ids[ name ]
    return nil if (idx >= @elements.length) 

    @elements[ idx ]
  end

  def write_field( name, value )
    idx = self.class.field_ids[ name ]

    if (idx >= @elements.length)
      # make some space for the incoming field, missing items are assumed to
      # be empty, so this is valid per the spec -mg
      missing = ("," * (idx-@elements.length)).split(',',-1)
      @elements += missing
    end


    @elements[ idx ] = value
  end

  @elements = []
  @field_ids = {}


end

def Date.from_hl7( hl7_date )
end

def Date.to_hl7_short( ruby_date )
end

def Date.to_hl7_med( ruby_date )
end

def Date.to_hl7_long( ruby_date )
end

class HL7::Message::Segment::MSH < HL7::Message::Segment
  segment_weight -1 # the msh should always start a message
  add_field :name=>:field_sep, :idx=>1
  add_field :name=>:enc_chars, :idx=>2
  add_field :name=>:sending_app, :idx=>3
  add_field :name=>:sending_facility, :idx=>4
  add_field :name=>:recv_app, :idx=>5
  add_field :name=>:recv_facility, :idx=>6
  add_field :name=>:time, :idx=>7
  add_field :name=>:security, :idx=>8
  add_field :name=>:message_type, :idx=>9
  add_field :name=>:message_control_id, :idx=>10
  add_field :name=>:processing_id, :idx=>11
  add_field :name=>:version_id, :idx=>12
  add_field :name=>:seq, :idx=>13
  add_field :name=>:continue_ptr, :idx=>14
  add_field :name=>:accept_ack_type, :idx=>15
  add_field :name=>:app_ack_type, :idx=>16
  add_field :name=>:country_code, :idx=>17
  add_field :name=>:charset, :idx=>18

end

class HL7::Message::Segment::MSA < HL7::Message::Segment
  segment_weight 0 # should occur after the msh segment
  add_field :name=>:sid, :idx=>1
  add_field :name=>:ack_code, :idx=>2
  add_field :name=>:control_id, :idx=>3
  add_field :name=>:text, :idx=>4
  add_field :name=>:expected_seq, :idx=>5
  add_field :name=>:delayed_ack_type, :idx=>6
  add_field :name=>:error_cond, :idx=>7
end

class HL7::Message::Segment::EVN < HL7::Message::Segment
end

class HL7::Message::Segment::PID < HL7::Message::Segment
  add_field :name=>:set_id, :idx=>1
  add_field :name=>:patient_id, :idx=>2
  add_field :name=>:patient_id_list, :idx=>3
  add_field :name=>:alt_patient_id, :idx=>4
  add_field :name=>:patient_name, :idx=>5
  add_field :name=>:mother_maiden_name, :idx=>6
  add_field :name=>:patient_dob, :idx=>7
end

class HL7::Message::Segment::PV1 < HL7::Message::Segment
end

class HL7::Message::Segment::NTE < HL7::Message::Segment
  segment_weight 4
  add_field :name=>:set_id, :idx=>1
  add_field :name=>:source, :idx=>2
  add_field :name=>:comment, :idx=>3
  add_field :name=>:comment_type, :idx=>4
end

class HL7::Message::Segment::ORU < HL7::Message::Segment
end

class HL7::Message::Segment::Default < HL7::Message::Segment
  # all segments have an order-id 
  add_field :name=>:sid, :idx=> 1
end

# vim:tw=78:sw=2:ts=2:et:fdm=marker:
