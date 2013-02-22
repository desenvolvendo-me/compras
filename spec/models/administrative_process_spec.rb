# encoding: utf-8
require 'model_helper'
require 'lib/signable'
require 'app/models/administrative_process'
require 'app/models/employee'
require 'app/models/licitation_process'
require 'app/models/administrative_process_budget_allocation'
require 'app/models/administrative_process_budget_allocation_item'
require 'app/models/budget_allocation'
require 'app/models/administrative_process_liberation'
require 'app/models/purchase_solicitation_item_group'
require 'app/models/purchase_solicitation_budget_allocation_item'
require 'app/business/judgment_form_licitation_kind_by_object_type'

describe AdministrativeProcess do
  it 'should return process/year as to_s' do
    subject.process = '1'
    subject.year = '2012'
    expect(subject.to_s).to eq '1/2012'
  end

  it { should belong_to :responsible }
  it { should belong_to :judgment_form }
  it { should belong_to :purchase_solicitation_item_group }
  it { should belong_to :purchase_solicitation }

  it { should have_one(:licitation_process).dependent(:restrict) }
  it { should have_one(:administrative_process_liberation).dependent(:destroy) }
  it { should have_one(:delivery_location).through(:purchase_solicitation) }
  it { should have_many(:administrative_process_budget_allocations).dependent(:destroy) }
  it { should have_many(:items).through(:administrative_process_budget_allocations) }
  it { should have_many(:materials).through(:items) }
  it { should have_many(:purchase_solicitation_budget_allocation_items) }
  it { should have_many(:purchase_solicitation_items) }

  it { should validate_duplication_of(:budget_allocation_id).on(:administrative_process_budget_allocations) }

  it { should validate_presence_of :year }
  it { should validate_presence_of :date }
  it { should validate_presence_of :object_type }
  it { should validate_presence_of :description }
  it { should validate_presence_of :judgment_form }
  it { should validate_presence_of :responsible }
  it { should validate_presence_of :status }
  it { should validate_presence_of :modality }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('212').for(:year) }
  it { should_not allow_value('2a12').for(:year) }

  it { should have_db_index([:process, :year]).unique(true) }

  describe 'validate the modality depending on object_type' do
    context 'when the modality is not on modalities available for the type of object' do
      it "should raise error" do
        subject.stub(:object_type => AdministrativeProcessObjectType::CALL_NOTICE)
        subject.stub(:modality => Modality::TAKEN_PRICE)

        subject.valid?

        expect(subject.errors[:modality]).to include('não está incluído na lista')
      end
    end

    context 'when the modality is on modalities available for the type of object' do
      it "should not raise error" do
        subject.stub(:object_type => AdministrativeProcessObjectType::PURCHASE_AND_SERVICES)
        subject.stub(:modality => Modality::TAKEN_PRICE)

        subject.valid?

        expect(subject.errors[:modality]).to be_empty
      end
    end
  end

  context 'with judgment_form' do
    let :judgment_form do
      double(:judgment_form)
    end

    it 'should not be valid when valid_licitation_kind is false' do
      judgment_form.stub(:licitation_kind).and_return(:licitation_kind)

      subject.stub(:judgment_form).and_return(judgment_form)
      subject.stub(:object_type).and_return(:disposals_of_assets)


      JudgmentFormLicitationKindByObjectType.any_instance.should_receive(:valid_licitation_kind?).
                                             with(:disposals_of_assets, :licitation_kind).
                                             and_return(false)

      subject.valid?
      expect(subject.errors[:judgment_form]).to include "tipo de licitação da forma de julgamento inválida para o tipo de objeto ()"
    end

    it 'should be valid when valid_licitation_kind is true' do
      judgment_form.stub(:licitation_kind).and_return(:licitation_kind)

      subject.stub(:judgment_form).and_return(judgment_form)
      subject.stub(:object_type).and_return(:disposals_of_assets)


      JudgmentFormLicitationKindByObjectType.any_instance.should_receive(:valid_licitation_kind?).
                                             with(:disposals_of_assets, :licitation_kind).
                                             and_return(true)

      subject.valid?
      expect(subject.errors[:judgment_form]).not_to include "tipo de licitação da forma de julgamento inválida para o tipo de objeto ()"
    end
  end

  it 'should return 0 for total value of all budget allocations when have no allocations' do
    expect(subject.administrative_process_budget_allocations).to be_empty

    expect(subject.total_allocations_value).to eq 0
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
      expect(subject.signatures(signature_configuration_item_store)).to eq signature_configuration_items
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
    expect(subject).to be_allow_licitation_process
  end

  it "should allow licitation process when object type is construction_and_engineering_services" do
    subject.stub(:object_type => AdministrativeProcessObjectType::CONSTRUCTION_AND_ENGINEERING_SERVICES)
    expect(subject).to be_allow_licitation_process
  end

  it "should allow licitation process when object type is disposals_of_assets" do
    subject.stub(:object_type => AdministrativeProcessObjectType::DISPOSALS_OF_ASSETS)
    expect(subject).to be_allow_licitation_process
  end

  it "should not allow licitation process when object type is not construction_and_engineering_services neither purchase_and_services" do
    subject.stub(:object_type => AdministrativeProcessObjectType::CALL_NOTICE)
    expect(subject).not_to be_allow_licitation_process
  end

  describe 'attend_purchase_solicitation_items' do
    it 'should attend items' do
      subject.purchase_solicitation_items.should_receive(:attend!)

      subject.attend_purchase_solicitation_items
    end
  end

  describe 'fulfill_purchase_solicitation_items' do
    before do
      subject.should_receive(:purchase_solicitation_items).
              and_return([item, item2])
    end

    let(:item)  { double(:item) }
    let(:item2) { double(:item2) }

    it 'should fulfill items' do
      item.should_receive(:fulfill).with(subject)
      item2.should_receive(:fulfill).with(subject)

      subject.fulfill_purchase_solicitation_items
    end
  end

  describe 'remove_fulfill_purchase_solicitation_items' do
    before do
      subject.should_receive(:purchase_solicitation_items).
              and_return([item, item2])
    end

    let(:item)  { double(:item) }
    let(:item2) { double(:item2) }

    it 'should fulfill items' do
      item.should_receive(:fulfill).with(nil)
      item2.should_receive(:fulfill).with(nil)

      subject.remove_fulfill_purchase_solicitation_items
    end
  end

  describe 'partially_fulfilled_purchase_solicitation_items' do
    before do
      subject.should_receive(:purchase_solicitation_items).
              and_return([item, item2])
    end

    let(:item)  { double(:item) }
    let(:item2) { double(:item2) }

    it 'should fulfill items' do
      item.should_receive(:partially_fulfilled!)
      item2.should_receive(:partially_fulfilled!)

      subject.partially_fulfilled_purchase_solicitation_items
    end
  end

  context 'with purchase_solicitation_item_group' do
    let :purchase_solicitation_item_group do
      double(:purchase_solcitation_item_group)
    end

    it 'should not allow purchase_solicitation_item_group annulled' do
      purchase_solicitation_item_group.stub(:annulled?).and_return(true)
      subject.stub(:purchase_solicitation_item_group).and_return(purchase_solicitation_item_group)

      subject.valid?
      expect(subject.errors[:purchase_solicitation_item_group]).to include(I18n.translate('errors.messages.is_annulled'))
    end

    it 'should allow purchase_solicitation_item_group not annulled' do
      purchase_solicitation_item_group.stub(:annulled?).and_return(false)
      subject.stub(:purchase_solicitation_item_group).and_return(purchase_solicitation_item_group)

      subject.valid?
      expect(subject.errors[:purchase_solicitation_item_group]).to_not include(I18n.translate('errors.messages.is_annulled'))
    end
  end

  it 'should not allow purchase_solicitation and purchase_solicitation_item_group at same time' do
    purchase_solicitation = double(:purchase_solicitation)
    purchase_solicitation_item_group = double(:purchase_solicitation_item_group, :annulled? => false)

    subject.stub(:purchase_solicitation).and_return(purchase_solicitation)
    subject.stub(:purchase_solicitation_item_group).
            and_return(purchase_solicitation_item_group)

    subject.valid?

    expect(subject.errors[:purchase_solicitation]).to include(I18n.translate('errors.messages.should_be_blank_if_item_group_is_present'))
  end
end
