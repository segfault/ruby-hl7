# $Id$
require 'ruby-hl7'
class HL7::Message::Segment::MSA < HL7::Message::Segment
  weight 0 # should occur after the msh segment
  add_field :name=>:ack_code
  add_field :name=>:control_id
  add_field :name=>:text
  add_field :name=>:expected_seq
  add_field :name=>:delayed_ack_type
  add_field :name=>:error_cond
end

