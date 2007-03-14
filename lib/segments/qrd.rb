# $Id$
require 'ruby-hl7'
class HL7::Message::Segment::QRD < HL7::Message::Segment
  weight 84
  add_field :name=>:query_date
  add_field :name=>:query_format_code
  add_field :name=>:query_priority
  add_field :name=>:query_id
  add_field :name=>:deferred_response_type
  add_field :name=>:deferred_response_date
  add_field :name=>:quantity_limited_request
  add_field :name=>:who_subject_filter
  add_field :name=>:what_subject_filter
  add_field :name=>:what_department_code
  add_field :name=>:what_data_code
  add_field :name=>:query_results_level
end
