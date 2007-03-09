# $Id$
require 'ruby-hl7'
class HL7::Message::Segment::MSH < HL7::Message::Segment
  weight -1 # the msh should always start a message
  add_field :name=>:enc_chars, :idx=>1
  add_field :name=>:sending_app, :idx=>2
  add_field :name=>:sending_facility, :idx=>3
  add_field :name=>:recv_app, :idx=>4
  add_field :name=>:recv_facility, :idx=>5
  add_field :name=>:time, :idx=>6
  add_field :name=>:security, :idx=>7
  add_field :name=>:message_type, :idx=>8
  add_field :name=>:message_control_id, :idx=>9
  add_field :name=>:processing_id, :idx=>10
  add_field :name=>:version_id, :idx=>11
  add_field :name=>:seq, :idx=>12
  add_field :name=>:continue_ptr, :idx=>13
  add_field :name=>:accept_ack_type, :idx=>14
  add_field :name=>:app_ack_type, :idx=>15
  add_field :name=>:country_code, :idx=>16
  add_field :name=>:charset, :idx=>17
end
