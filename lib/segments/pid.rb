# $Id$
require 'ruby-hl7'
class HL7::Message::Segment::PID < HL7::Message::Segment
  add_field :name=>:set_id, :idx=>1
  add_field :name=>:patient_id, :idx=>2
  add_field :name=>:patient_id_list, :idx=>3
  add_field :name=>:alt_patient_id, :idx=>4
  add_field :name=>:patient_name, :idx=>5
  add_field :name=>:mother_maiden_name, :idx=>6
  add_field :name=>:patient_dob, :idx=>7
end
