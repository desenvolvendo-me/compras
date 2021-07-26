require 'model_helper'
require 'lib/annullable'
require 'lib/signable'
require 'app/models/budget_structure'
require 'app/models/expense_nature'
require 'app/models/budget_allocation'
require 'app/models/purchase_solicitation_budget_allocation'
require 'app/models/purchase_solicitation_item'
require 'app/models/budget_allocation'
require 'app/models/purchase_solicitation'
require 'app/models/purchase_solicitation_liberation'
require 'app/models/resource_annul'
require 'app/models/material.rb'
require 'app/models/budget_structure.rb'
require 'app/models/licitation_process'

describe PurchaseSolicitation do
  it 'should return the code/accounting_year in to_s method' do
    subject.accounting_year = 2012
    subject.stub(:budget_structure => "01.01.001 - SECRETARIA DA EDUCAÇÃO")
    subject.stub(:responsible => "CARLOS DORNELES")
    subject.code = 2

    expect(subject.to_s).to eq "2/2012"
  end

  it { should have_and_belong_to_many(:licitation_processes) }
  it { should have_and_belong_to_many(:price_collections) }
  it { should have_many(:purchase_solicitation_budget_allocations).dependent(:destroy).order(:id) }
  it { should have_many(:items).dependent(:restrict)}
  it { should have_many(:purchase_solicitation_liberations).dependent(:destroy).order(:sequence) }
  it { should have_many(:price_collection_items).through(:price_collections) }
  it { should have_many(:price_collection_proposal_items).through(:price_collection_items) }
  it { should have_one(:annul).dependent(:destroy) }
  it { should belong_to :responsible }
  it { should belong_to :delivery_location }
  it { should belong_to :liberator }

  it { should auto_increment(:code).by(:accounting_year) }

  describe "updating columns" do
    describe '#annul!' do
      it 'should updates the service status to annulled' do
        subject.should_receive(:update_column).with(:service_status, PurchaseSolicitationServiceStatus::ANNULLED)

        subject.annul!
      end
    end

    describe '#change_status!' do
      let :liberation do
        double :liberation
      end

      it 'should updates the service status to annulled' do
        subject.stub(:liberation).and_return(liberation)
        subject.should_receive(:update_column).with(:service_status, 'liberated')

        subject.change_status!('liberated')
      end
    end

    describe '#liberate!' do
      it 'should change service_status to liberated' do
        subject.should_receive(:update_column).with(:service_status, 'liberated')

        subject.liberate!
      end
    end

    describe '#attend!' do
      it 'should change service_status to attended' do
        subject.should_receive(:update_column).with(:service_status, 'attended')

        subject.attend!
      end
    end

    describe '#buy!' do
      it "should update the service_status to 'in_purchase_process'" do
        subject.should_receive(:update_column).
          with(:service_status, PurchaseSolicitationServiceStatus::IN_PURCHASE_PROCESS)

        subject.buy!
      end
    end

    describe '#pending!' do
      it "should update the service_status to 'in_purchase_process'" do
        subject.should_receive(:update_column).
          with(:service_status, PurchaseSolicitationServiceStatus::PENDING)

        subject.pending!
      end
    end

    describe '#partially_fulfilled!' do
      it "should update the service_status to 'in_purchase_process'" do
        subject.should_receive(:update_column).
          with(:service_status, PurchaseSolicitationServiceStatus::PARTIALLY_FULFILLED)

        subject.partially_fulfilled!
      end
    end
  end

  it 'should be editable when is pending' do
    subject.service_status = PurchaseSolicitationServiceStatus::PENDING

    expect(subject).to be_editable
  end

  it 'should be editable when is returned' do
    subject.service_status = PurchaseSolicitationServiceStatus::RETURNED

    expect(subject).to be_editable
  end

  it 'should not be editable when is not returned neither pending' do
    subject.service_status = PurchaseSolicitationServiceStatus::ANNULLED

    expect(subject).not_to be_editable
  end

  describe "#purchase_solicitation_budget_allocations_by_material" do
    it "returns all budget allocations with materials of a given set" do
      material_ids = [-1, -2]
      budget_allocations = double(:budget_allocations)
      subject.stub(:purchase_solicitation_budget_allocations => budget_allocations)

      budget_allocations.should_receive(:by_material).with(material_ids)
      subject.purchase_solicitation_budget_allocations_by_material(material_ids)
    end
  end

  describe "#can_be_grouped?" do
    it "returns true if purchase solicitation is approved" do
      subject.service_status = "liberated"

      expect(subject.can_be_grouped?).to be true
    end

    it "returns true if purchase solicitation is partially fulfilled" do
      subject.service_status = "partially_fulfilled"

      expect(subject.can_be_grouped?).to be true
    end

    it "returns false otherwise" do
      subject.service_status = "attended"

      expect(subject.can_be_grouped?).to be false
    end
  end

  context '#active_purchase_solicitation_liberation' do
    before do
      subject.stub(:purchase_solicitation_liberations).
              and_return(purchase_solicitation_liberations)
    end

    let(:purchase_solicitation_liberations) { double(:purchase_solicitation_liberations) }

    it 'should return last purchase_solicitation_liberation' do
      purchase_solicitation_liberations.should_receive(:last)

      subject.active_purchase_solicitation_liberation
    end

    describe 'active_purchase_solicitation_liberation_liberated' do
      before do
        purchase_solicitation_liberations.should_receive(:last).at_least(1).times.and_return(active)
      end

      let(:active) { double(:active) }

      it 'should be false when active_purchase_solicitation_liberation is not liberated' do
        active.stub(:liberated?).and_return(false)

        expect(subject.active_purchase_solicitation_liberation_liberated?).to be_false
      end

      it 'should be true when active_purchase_solicitation_liberation is liberated' do
        active.stub(:liberated?).and_return(true)

        expect(subject.active_purchase_solicitation_liberation_liberated?).to be_true
      end
    end
  end

  describe '#total_items_value' do
    it 'should return 0 as the total value of items when have no items' do
      expect(subject.items).to be_empty

      expect(subject.total_items_value).to eq 0
    end

    it 'should calculate the total value of items' do
      subject.stub(:items).and_return([
        double(:estimated_total_price_rounded  => 10),
        double(:estimated_total_price_rounded => 20),
        double(:estimated_total_price_rounded => 15)
      ])

      expect(subject.total_items_value).to eq 45
    end
  end

  describe '#budget_allocations' do
    before do
      subject.stub :purchase_solicitation_budget_allocations => [purchase_solicitation_budget_allocation]
    end

    let :purchase_solicitation_budget_allocation do
      double(:purchase_solicitation_budget_allocation, :budget_allocation => budget_allocation)
    end

    let :budget_allocation do
      double(:budget_allocation)
    end

    it 'delegates to purchase_solicitation_budget_allocations' do
      expect(subject.budget_allocations).to eq [budget_allocation]
    end

    context 'when purchase_solicitation_budget_allocations is nil' do
      before do
        subject.stub :purchase_solicitation_budget_allocations => nil
      end

      it 'returns nil' do
        expect(subject.budget_allocations).to be_nil
      end
    end
  end
end
