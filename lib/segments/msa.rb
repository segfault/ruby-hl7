# $Id$
require 'ruby-hl7'
class HL7::Message::Segment::MSA < HL7::Message::Segment
  weight 0 # should occur after the msh segment
  add_field :name=>:sid, :idx=>1
  add_field :name=>:ack_code, :idx=>2
  add_field :name=>:control_id, :idx=>3
  add_field :name=>:text, :idx=>4
  add_field :name=>:expected_seq, :idx=>5
  add_field :name=>:delayed_ack_type, :idx=>6
  add_field :name=>:error_cond, :idx=>7
end

