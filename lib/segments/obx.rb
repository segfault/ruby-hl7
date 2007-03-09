# $Id$
require 'ruby-hl7'
class HL7::Message::Segment::OBX < HL7::Message::Segment
  add_field :name=>:set_id, :idx=> 1
end

