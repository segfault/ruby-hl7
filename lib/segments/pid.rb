# $Id$
require 'ruby-hl7'
class HL7::Message::Segment::PID < HL7::Message::Segment
  weight 1
  add_field :name=>:set_id
  add_field :name=>:patient_id
  add_field :name=>:patient_id_list
  add_field :name=>:alt_patient_id
  add_field :name=>:patient_name
  add_field :name=>:mother_maiden_name
  add_field :name=>:patient_dob
  add_field :name=>:admin_sex do |sex|
    unless /^[FMOUAN]$/.match(sex) || sex == nil
      raise HL7::InvalidDataError.new( "bad administrative sex value (not F|M|O|U|A|N)" )
    end
    sex = "" unless sex
    sex
  end
  add_field :name=>:patient_alias
  add_field :name=>:race
  add_field :name=>:address
  add_field :name=>:country_code
  add_field :name=>:phone_home
  add_field :name=>:phone_business
  add_field :name=>:primary_language
  add_field :name=>:marital_status
  add_field :name=>:religion
  add_field :name=>:account_number
  add_field :name=>:social_security_num
  add_field :name=>:mothers_id
  add_field :name=>:ethnic_group
  add_field :name=>:birthplace
  add_field :name=>:multi_birth
  add_field :name=>:birth_order
  add_field :name=>:citizenship
  add_field :name=>:vet_status
  add_field :name=>:nationality
  add_field :name=>:death_date
  add_field :name=>:death_indicator
  add_field :name=>:id_unknown_indicator
  add_field :name=>:id_readability_code
  add_field :name=>:last_update_date
  add_field :name=>:last_update_facility
  add_field :name=>:species_code
  add_field :name=>:breed_code
  add_field :name=>:strain
  add_field :name=>:production_class_code
  add_field :name=>:tribal_citizenship
end
