# $Id$
require 'ruby-hl7'
class HL7::Message::Segment::OBR < HL7::Message::Segment
  add_field :name=>:set_id, :idx=> 1
  has_children
end
