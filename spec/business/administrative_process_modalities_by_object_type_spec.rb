require 'unit_helper'
require 'enumerate_it'
require 'app/business/administrative_process_modalities_by_object_type'
require 'app/enumerations/administrative_process_modality'
require 'app/enumerations/administrative_process_object_type'

describe AdministrativeProcessModalitiesByObjectType do
  it 'should verify status for type' do
    expect(subject.verify_modality(AdministrativeProcessObjectType::PURCHASE_AND_SERVICES, AdministrativeProcessModality::MAKING_COST_FOR_CONSTRUCTIONS_AND_ENGINEERING_SERVICES)).not_to be_true
    expect(subject.verify_modality(AdministrativeProcessObjectType::PURCHASE_AND_SERVICES, AdministrativeProcessModality::MAKING_COST_FOR_PURCHASES_AND_SERVICES)).to be_true
    expect(subject.verify_modality(AdministrativeProcessObjectType::PURCHASE_AND_SERVICES, AdministrativeProcessModality::INVITATION_FOR_PURCHASES_AND_SERVICES)).to be_true
    expect(subject.verify_modality(AdministrativeProcessObjectType::PURCHASE_AND_SERVICES, AdministrativeProcessModality::AUCTION)).not_to be_true
  end
end
