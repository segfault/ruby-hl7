# $Id$
require 'ruby-hl7'
class HL7::Message::Segment::QRF < HL7::Message::Segment
  weight 85
  add_field :name=>:where_subject_filter
  add_field :name=>:when_start_date
  add_field :name=>:when_end_date
  add_field :name=>:what_user_qualifier
  add_field :name=>:other_qry_subject_filter
  add_field :name=>:which_date_qualifier
  add_field :name=>:which_date_status_qualifier
  add_field :name=>:date_selection_qualifier
  add_field :name=>:when_timing_qualifier
  add_field :name=>:search_confidence_threshold
end
