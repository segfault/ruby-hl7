# $Id$
require 'ruby-hl7'
class HL7::Message::Segment::OBR < HL7::Message::Segment
  weight 89 # obr.weight-1
  has_children
  add_field :name=>:set_id
  add_field :name=>:placer_order_number
  add_field :name=>:filler_order_number
  add_field :name=>:priority
  add_field :name=>:requested_date
  add_field :name=>:observation_date
  add_field :name=>:observation_end_date
  add_field :name=>:collection_volume
  add_field :name=>:collector_identifier
  add_field :name=>:specimen_action_code
  add_field :name=>:danger_code
  add_field :name=>:relevant_clinical_info
  add_field :name=>:specimen_received_date
  add_field :name=>:specimen_source
  add_field :name=>:ordering_provider
  add_field :name=>:order_callback_phone_number
  add_field :name=>:placer_field_1
  add_field :name=>:placer_field_2
  add_field :name=>:filer_field_1
  add_field :name=>:filer_field_2
  add_field :name=>:results_status_change_date
  add_field :name=>:charge_to_practice
  add_field :name=>:parent_result
  add_field :name=>:quantity_timing
  add_field :name=>:result_copies_to
  add_field :name=>:parent
  add_field :name=>:transport_mode
  add_field :name=>:reason_for_study
  add_field :name=>:principal_result_interpreter
  add_field :name=>:assistant_result_interpreter
  add_field :name=>:technician
  add_field :name=>:transcriptionist
  add_field :name=>:scheduled_date
  add_field :name=>:number_of_sample_containers
  add_field :name=>:transport_logistics_of_sample
  add_field :name=>:collectors_comment
  add_field :name=>:transport_arrangement_responsibility
  add_field :name=>:transport_arranged
  add_field :name=>:escort_required
  add_field :name=>:planned_patient_transport_comment
  add_field :name=>:procedure_code
  add_field :name=>:procedure_code_modifier
  add_field :name=>:placer_supplemental_service_info
  add_field :name=>:filler_supplemental_service_info
  add_field :name=>:medically_necessary_dup_procedure_reason #longest method name ever. sry.
  add_field :name=>:result_handling
end
