# encoding: utf-8
require 'model_helper'
require 'app/models/administrative_process'
require 'app/models/budget_allocation'
require 'app/models/organogram'
require 'app/models/employee'
require 'app/models/licitation_process'
require 'app/enumerations/administrative_process_modality'
require 'app/enumerations/administrative_process_object_type'
require 'app/business/administrative_process_modalities_by_object_type'

describe AdministrativeProcess do
  it 'should return process/year as to_s' do
    subject.process = '1'
    subject.year = '2012'
    subject.to_s.should eq '1/2012'
  end

  it { should belong_to :organogram }
  it { should belong_to :budget_allocation }
  it { should belong_to :responsible }
  it { should belong_to :judgment_form }

  it { should have_many(:licitation_processes).dependent(:restrict) }

  it { should validate_presence_of :year }
  it { should validate_presence_of :date }
  it { should validate_presence_of :organogram }
  it { should validate_presence_of :value_estimated }
  it { should validate_presence_of :budget_allocation }
  it { should validate_presence_of :modality }
  it { should validate_presence_of :object_type }
  it { should validate_presence_of :description }
  it { should validate_presence_of :judgment_form }
  it { should validate_presence_of :responsible }
  it { should validate_presence_of :status }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('212').for(:year) }
  it { should_not allow_value('2a12').for(:year) }

  it { should have_db_index([:process, :year]).unique(true) }

  it { should_not allow_mass_assignment_of(:delivery_date) }

  it "should validate the modality depending on object_type" do
    def test_type(type, modalities_for_type)
      subject.object_type = type
      modalities_for_type.each do |modality|
        subject.modality = modality

        subject.valid?
        subject.errors[:modality].should_not include(I18n.translate('errors.messages.inclusion'))
      end

      (AdministrativeProcessModality.to_a - modalities_for_type).each do |modality|
        subject.modality = modality

        subject.valid?
        subject.errors[:modality].should include(I18n.translate('errors.messages.inclusion'))
      end
    end

    test_type(AdministrativeProcessObjectType::PURCHASE_AND_SERVICES, [
              AdministrativeProcessModality::MAKING_COST_FOR_CONSTRUCTIONS_AND_ENGINEERING_SERVICES,
              AdministrativeProcessModality::MAKING_COST_FOR_PURCHASES_AND_SERVICES,
              AdministrativeProcessModality::INVITATION_FOR_PURCHASES_AND_ENGINEERING_SERVICES,
              AdministrativeProcessModality::COMPETITION_FOR_PURCHASES_AND_SERVICES,
              AdministrativeProcessModality::PRESENCE_TRADING,
              AdministrativeProcessModality::ELECTRONIC_TRADING,
              AdministrativeProcessModality::EXEMPTION_FOR_PURCHASES_AND_SERVICES,
              AdministrativeProcessModality::UNENFORCEABILITY])

    test_type(AdministrativeProcessObjectType::CONSTRUCTION_AND_ENGINEERING_SERVICES, [
              AdministrativeProcessModality::MAKING_COST_FOR_CONSTRUCTIONS_AND_ENGINEERING_SERVICES,
              AdministrativeProcessModality::INVITATION_FOR_CONSTRUCTIONS_ENGINEERING_SERVICES,
              AdministrativeProcessModality::COMPETITION_FOR_CONSTRUCTIONS_AND_ENGINEERING_SERVICES,
              AdministrativeProcessModality::ELECTRONIC_TRADING,
              AdministrativeProcessModality::EXEMPTION_FOR_CONSTRUCTIONS_AND_ENGINEERING_SERVICES,
              AdministrativeProcessModality::UNENFORCEABILITY,
              AdministrativeProcessModality::COMPETITION])

    test_type(AdministrativeProcessObjectType::DISPOSALS_OF_ASSETS, [AdministrativeProcessModality::AUCTION])

    test_type(AdministrativeProcessObjectType::CONCESSIONS_AND_PERMITS, [AdministrativeProcessModality::COMPETITION_FOR_GRANTS])

    test_type(AdministrativeProcessObjectType::CALL_NOTICE, [AdministrativeProcessModality::COMPETITION, AdministrativeProcessModality::OTHER_MODALITIES])
  end
end
