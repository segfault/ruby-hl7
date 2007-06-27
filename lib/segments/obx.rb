# $Id$
require 'ruby-hl7'
class HL7::Message::Segment::OBX < HL7::Message::Segment
  weight 90
  has_children [:NTE]
  add_field :name=>:set_id
  add_field :name=>:value_type
  add_field :name=>:observation_id
  add_field :name=>:observation_sub_id
  add_field :name=>:observation_value
  add_field :name=>:units
  add_field :name=>:references_range
  add_field :name=>:probability
  add_field :name=>:nature_of_abnormal_test
  add_field :name=>:observation_result_status
  add_field :name=>:effective_date_of_reference_range
  add_field :name=>:user_defined_access_checks
  add_field :name=>:observation_date
  add_field :name=>:producer_id
  add_field :name=>:responsible_observer
  add_field :name=>:observation_method
  add_field :name=>:equipment_instance_id
  add_field :name=>:analysis_date
end

