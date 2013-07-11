# encoding: UTF-8
require 'ruby-hl7'
class HL7::Message::Segment::ORC < HL7::Message::Segment
  weight 4
  add_field :order_control, :idx=>1
  add_field :placer_order_number, :idx=>2
  add_field :filler_order_number, :idx=>3
  add_field :order_status, :idx=>5
  add_field :transaction_timestamp, :idx=>9
  add_field :ordering_phys, :idx=>12
  add_field :enterer_location, :idx=>13
  add_field :call_back_phone, :idx=>14
end
