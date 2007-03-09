# $Id$
require 'ruby-hl7'
class HL7::Message::Segment::NTE < HL7::Message::Segment
  weight 4
  add_field :name=>:set_id, :idx=>1
  add_field :name=>:source, :idx=>2
  add_field :name=>:comment, :idx=>3
  add_field :name=>:comment_type, :idx=>4
end
