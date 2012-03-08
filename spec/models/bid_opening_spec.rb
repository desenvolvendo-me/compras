# encoding: utf-8
require 'model_helper'
require 'app/models/bid_opening'
require 'app/models/budget_allocation'
require 'app/models/organogram'
require 'app/models/employee'
require 'app/enumerations/bid_opening_modality'
require 'app/enumerations/bid_opening_object_type'
require 'app/business/bid_opening_modalities_by_object_type'

describe BidOpening do
  it 'should return process/year as to_s' do
    subject.process = '1'
    subject.year = '2012'
    subject.to_s.should eq '1/2012'
  end

  it { should belong_to :organogram }
  it { should belong_to :budget_allocation }
  it { should belong_to :responsible }
  it { should belong_to :judgment_form }

  it { should validate_presence_of :year }
  it { should validate_presence_of :date }
  it { should validate_presence_of :organogram }
  it { should validate_presence_of :value_estimated }
  it { should validate_presence_of :budget_allocation }
  it { should validate_presence_of :modality }
  it { should validate_presence_of :object_type }
  it { should validate_presence_of :description }
  it { should validate_presence_of :judgment_form }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('212').for(:year) }
  it { should_not allow_value('2a12').for(:year) }

  it { should have_db_index([:process, :year]).unique(true) }

  it { should_not allow_mass_assignment_of(:delivery_date) }

  it "should validate the modality depending on object_type" do
    modality_enum = BidOpeningModality

    def test_type(type, modalities_for_type)
      modality_enum = BidOpeningModality

      subject.object_type = type
      modalities_for_type.each do |modality|
        subject.modality = modality

        subject.valid?
        subject.errors[:modality].should_not include(I18n.translate('errors.messages.inclusion'))
      end

      (modality_enum.to_a - modalities_for_type).each do |modality|
        subject.modality = modality

        subject.valid?
        subject.errors[:modality].should include(I18n.translate('errors.messages.inclusion'))
      end
    end

    test_type(BidOpeningObjectType::PURCHASE_AND_SERVICES, [
              BidOpeningModality::MAKING_COST_FOR_CONSTRUCTIONS_AND_ENGINEERING_SERVICES,
              BidOpeningModality::MAKING_COST_FOR_PURCHASES_AND_SERVICES,
              BidOpeningModality::INVITATION_FOR_PURCHASES_AND_ENGINEERING_SERVICES,
              BidOpeningModality::COMPETITION_FOR_PURCHASES_AND_SERVICES,
              BidOpeningModality::PRESENCE_TRADING,
              BidOpeningModality::ELECTRONIC_TRADING,
              BidOpeningModality::EXEMPTION_FOR_PURCHASES_AND_SERVICES,
              BidOpeningModality::UNENFORCEABILITY])

    test_type(BidOpeningObjectType::CONSTRUCTION_AND_ENGINEERING_SERVICES, [
              BidOpeningModality::MAKING_COST_FOR_CONSTRUCTIONS_AND_ENGINEERING_SERVICES,
              BidOpeningModality::INVITATION_FOR_CONSTRUCTIONS_ENGINEERING_SERVICES,
              BidOpeningModality::COMPETITION_FOR_CONSTRUCTIONS_AND_ENGINEERING_SERVICES,
              BidOpeningModality::ELECTRONIC_TRADING,
              BidOpeningModality::EXEMPTION_FOR_CONSTRUCTIONS_AND_ENGINEERING_SERVICES,
              BidOpeningModality::UNENFORCEABILITY,
              BidOpeningModality::COMPETITION])

    test_type(BidOpeningObjectType::DISPOSALS_OF_ASSETS, [BidOpeningModality::AUCTION])

    test_type(BidOpeningObjectType::CONCESSIONS_AND_PERMITS, [BidOpeningModality::COMPETITION_FOR_GRANTS])

    test_type(BidOpeningObjectType::CALL_NOTICE, [BidOpeningModality::COMPETITION, BidOpeningModality::OTHER_MODALITIES])
  end
end
