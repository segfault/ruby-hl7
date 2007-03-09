# $Id$
require 'ruby-hl7'
class HL7::Message::Segment::EVN < HL7::Message::Segment
  weight 0 # should occur after the MSH segment 
  add_field :name=>:type_code, :idx=>1
  add_field :name=>:recorded_date, :idx=>2
  add_field :name=>:planned_date, :idx=>3
  add_field :name=>:reason_code, :idx=>4
  add_field :name=>:operator_id, :idx=>5
  add_field :name=>:event_occurred, :idx=>6
  add_field :name=>:event_facility, :idx=>6
end
