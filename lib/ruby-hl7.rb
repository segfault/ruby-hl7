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
    if (raw_segment.kind_of? Array)
      @elements = raw_segment
    else
      @elements = raw_segment.split( element_delim, -1 )
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

  

  private
  def self.singleton
    class << self; self end
  end

  def self.add_field( options={} )
    options = {:name => :id, :idx =>0}.merge!( options )
    
    singleton.module_eval do
      @field_ids ||= {}
      #puts @field_ids
      name = options[:name]
      @field_ids[ name.to_sym ] = options[:idx].to_i 
      define_method( name ) do
        @field_ids[name.to_sym]
      end
    end

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
    raise HL7::Exception.new( "missing field" ) if (idx >= @elements.length)

    @elements[ idx ] = value.first
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
  add_field :name=>:id, :idx=> 1
  add_field :name=>:application, :idx=> 2
end

class HL7::Message::Segment::EVN < HL7::Message::Segment
end

class HL7::Message::Segment::PV1 < HL7::Message::Segment
end

class HL7::Message::Segment::NTE < HL7::Message::Segment
end

class HL7::Message::Segment::ORU < HL7::Message::Segment
end

class HL7::Message::Segment::Default < HL7::Message::Segment
  # all segments have an order-id 
  add_field :name=>:id, :idx=> 1
end

# vim:tw=78:sw=2:ts=2:et:fdm=marker:
