# encoding: utf-8
require 'model_helper'
require 'app/models/administrative_process'
require 'app/models/employee'
require 'app/models/licitation_process'
require 'app/models/administrative_process_budget_allocation'
require 'app/models/administrative_process_budget_allocation_item'
require 'app/models/budget_allocation'
require 'app/business/administrative_process_modalities_by_object_type'
require 'app/models/administrative_process_liberation'

describe AdministrativeProcess do
  it 'should return process/year as to_s' do
    subject.process = '1'
    subject.year = '2012'
    subject.to_s.should eq '1/2012'
  end

  it { should belong_to :responsible }
  it { should belong_to :judgment_form }

  it { should have_one(:licitation_process).dependent(:restrict) }
  it { should have_one(:administrative_process_liberation).dependent(:destroy) }
  it { should have_many(:administrative_process_budget_allocations).dependent(:destroy) }
  it { should have_many(:items).through(:administrative_process_budget_allocations) }
  it { should validate_duplication_of(:budget_allocation_id).on(:administrative_process_budget_allocations) }

  it { should validate_presence_of :year }
  it { should validate_presence_of :date }
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

  context 'signatures' do
    let :signature_configuration_item do
      double('SignatureConfigurationItem')
    end

    let :signature_configuration_item_store do
      double('SignatureConfigurationItemStore')
    end

    it 'should return related signatures' do
      signature_configuration_item_store.should_receive(:all_by_configuration_report).
                                         with('administrative_processes').
                                         and_return([signature_configuration_item])
      subject.signatures(signature_configuration_item_store).should eq [signature_configuration_item]
    end
  end

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
              AdministrativeProcessModality::MAKING_COST_FOR_PURCHASES_AND_SERVICES,
              AdministrativeProcessModality::INVITATION_FOR_PURCHASES_AND_ENGINEERING_SERVICES,
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
              AdministrativeProcessModality::COMPETITION,
              AdministrativeProcessModality::PRESENCE_TRADING])

    test_type(AdministrativeProcessObjectType::DISPOSALS_OF_ASSETS, [AdministrativeProcessModality::AUCTION, AdministrativeProcessModality::PRESENCE_TRADING])

    test_type(AdministrativeProcessObjectType::CONCESSIONS_AND_PERMITS, [AdministrativeProcessModality::COMPETITION_FOR_GRANTS])

    test_type(AdministrativeProcessObjectType::CALL_NOTICE, [AdministrativeProcessModality::COMPETITION])
  end

  it 'should return 0 for total value of all budget allocations when have no allocations' do
    subject.administrative_process_budget_allocations.should be_empty

    subject.total_allocations_value.should eq 0
  end

  it 'should be invite when modality is INVITATION_FOR_CONSTRUCTIONS_ENGINEERING_SERVICES' do
    subject.modality = AdministrativeProcessModality::INVITATION_FOR_CONSTRUCTIONS_ENGINEERING_SERVICES
    subject.should be_invited
  end

  it 'should be invite when modality is INVITATION_FOR_PURCHASES_AND_ENGINEERING_SERVICES' do
    subject.modality = AdministrativeProcessModality::INVITATION_FOR_PURCHASES_AND_ENGINEERING_SERVICES
    subject.should be_invited
  end

  it 'should not be invite when modality is not (INVITATION_FOR_CONSTRUCTIONS_ENGINEERING_SERVICES, INVITATION_FOR_PURCHASES_AND_ENGINEERING_SERVICES)' do
    subject.modality = AdministrativeProcessModality::MAKING_COST_FOR_CONSTRUCTIONS_AND_ENGINEERING_SERVICES
    subject.should_not be_invited
  end

  context 'signatures' do
    let :signature_configuration_item1 do
      double('SignatureConfigurationItem1')
    end

    let :signature_configuration_item2 do
      double('SignatureConfigurationItem2')
    end

    let :signature_configuration_item3 do
      double('SignatureConfigurationItem3')
    end

    let :signature_configuration_item4 do
      double('SignatureConfigurationItem4')
    end

    let :signature_configuration_item5 do
      double('SignatureConfigurationItem5')
    end

    let :signature_configuration_items do
      [
        signature_configuration_item1,
        signature_configuration_item2,
        signature_configuration_item3,
        signature_configuration_item4,
        signature_configuration_item5
      ]
    end

    let :signature_configuration_item_store do
      double('SignatureConfigurationItemStore')
    end

    it 'should return related signatures' do
      signature_configuration_item_store.should_receive(:all_by_configuration_report).with('administrative_processes').and_return(signature_configuration_items)
      subject.signatures(signature_configuration_item_store).should eq signature_configuration_items
    end
  end

  describe '#update_status!' do
    it 'update the status attribute with the given string' do
      subject.should_receive(:update_column).with(:status, 'released')

      subject.update_status('released')
    end
  end

  it "should allow licitation process when object type is purchase and services" do
    subject.stub(:object_type => AdministrativeProcessObjectType::PURCHASE_AND_SERVICES)
    subject.should be_allow_licitation_process
  end

  it "should allow licitation process when object type is construction_and_engineering_services" do
    subject.stub(:object_type => AdministrativeProcessObjectType::CONSTRUCTION_AND_ENGINEERING_SERVICES)
    subject.should be_allow_licitation_process
  end

  it "should not allow licitation process when object type is not construction_and_engineering_services neither purchase_and_services" do
    subject.stub(:object_type => AdministrativeProcessObjectType::CALL_NOTICE)
    subject.should_not be_allow_licitation_process
  end
end
