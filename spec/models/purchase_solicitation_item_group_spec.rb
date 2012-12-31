# encoding: utf-8
require 'model_helper'
require 'lib/signable'
require 'lib/annullable'
require 'app/models/purchase_solicitation_item_group'
require 'app/models/purchase_solicitation_item_group_material'
require 'app/models/direct_purchase'
require 'app/models/administrative_process'
require 'app/models/resource_annul'

describe PurchaseSolicitationItemGroup do
  it { should have_many(:purchase_solicitation_item_group_materials).dependent(:destroy) }
  it { should have_many(:purchase_solicitations).through(:purchase_solicitation_item_group_materials) }
  it { should have_many(:direct_purchases).dependent(:restrict) }
  it { should have_many(:administrative_processes).dependent(:restrict) }
  it { should have_one(:annul).dependent(:destroy) }

  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:purchase_solicitation_item_group_materials).with_message("deve ter ao menos um material") }

  it 'should be description as #to_s method' do
    subject.description = 'agrupamento de gasolina'

    expect(subject.to_s).to eq 'agrupamento de gasolina'
  end

  context 'total_purchase_solicitation_budget_allocations_sum' do
    let :purchase_solicitations do
      [
        double(:item1, :total_allocations_items_value => 20),
        double(:item2, :total_allocations_items_value => 15)
      ]
    end

    it 'should return the sum of total_purchase_solicitation_budget_allocations' do
      subject.stub(:purchase_solicitations).and_return(purchase_solicitations)

      expect(subject.total_purchase_solicitation_budget_allocations_sum).to eq 35
    end
  end

  it 'should be annulled if has a related annul object' do
    subject.stub(:status).and_return(PurchaseSolicitationItemGroupStatus::ANNULLED)

    expect(subject).to be_annulled
  end

  it 'should not be annulled if does not have a related annul object' do
    subject.stub(:status).and_return(PurchaseSolicitationItemGroupStatus::PENDING)

    expect(subject).not_to be_annulled
  end

  context 'editable' do
    let :direct_purchases do
      [
        double(:direct_purchase1),
        double(:direct_purchase2)
      ]
    end

    let :administrative_processes do
      [
        double(:administrative_process1),
        double(:administrative_process2)
      ]
    end

    it 'should not be editable if has direct_purchases' do
      subject.stub(:direct_purchases).and_return(direct_purchases)

      expect(subject).not_to be_editable
    end

    it 'should not be editable if has administrative_processes' do
      subject.stub(:administrative_processes).and_return(administrative_processes)

      expect(subject).not_to be_editable
    end

    it 'should not be editable if has administrative_processes and direct_purchases' do
      subject.stub(:administrative_processes).and_return(administrative_processes)
      subject.stub(:direct_purchases).and_return(direct_purchases)

      expect(subject).not_to be_editable
    end

    it 'should be editable if does not have administrative_process neither direct_purchases' do
      expect(subject).to be_editable
    end
  end

  context 'annullable' do
    let :direct_purchases do
      [
        double(:direct_purchase1),
        double(:direct_purchase2)
      ]
    end

    let :administrative_processes do
      [
        double(:administrative_process1),
        double(:administrative_process2)
      ]
    end

    it 'should not be annullable if has direct_purchases' do
      subject.stub(:direct_purchases).and_return(direct_purchases)

      expect(subject).not_to be_annullable
    end

    it 'should not be annullable if has administrative_processes' do
      subject.stub(:administrative_processes).and_return(administrative_processes)

      expect(subject).not_to be_annullable
    end

    it 'should not be annullable if has administrative_processes and direct_purchases' do
      subject.stub(:administrative_processes).and_return(administrative_processes)
      subject.stub(:direct_purchases).and_return(direct_purchases)

      expect(subject).not_to be_annullable
    end

    it 'should be annullable if does not have administrative_process neither direct_purchases' do
      expect(subject).to be_annullable
    end
  end

  context "#fulfill_items" do
    let(:process) { double(:process) }
    let(:group_material) { PurchaseSolicitationItemGroupMaterial.new }

    it "updates the fulfiller process of each item in the group" do
      subject.purchase_solicitation_item_group_materials = [group_material]

      group_material.should_receive(:fulfill_items).with(process)
      subject.fulfill_items(process)
    end
  end

  context 'purchase_solicitation_items' do
    let :purchase_solicitation_item_group_materials do
      []
    end

    let :purchase_solicitation_item_group_material1 do
      double(:purchase_solicitation_item_group_material1,
        :purchase_solicitation_items => [antivirus, office]
      )
    end

    let :purchase_solicitation_item_group_material2 do
      double(:purchase_solicitation_item_group_material2,
        :purchase_solicitation_items => [cadeira]
      )
    end

    let :antivirus do
      double(:antivirus, :id => 1)
    end

    let :office do
      double(:office, :id => 2)
    end

    let :cadeira do
      double(:office, :id => 3)
    end

    describe '#purchase_solicitation_items' do
      before do
        subject.stub(:purchase_solicitation_item_group_materials).
                and_return(purchase_solicitation_item_group_materials)
      end

      it 'should return items from purchase_solicitation_item_group_material' do
        purchase_solicitation_item_group_materials << purchase_solicitation_item_group_material1
        purchase_solicitation_item_group_materials << purchase_solicitation_item_group_material2

        expect(subject.purchase_solicitation_items).to eq [antivirus, office, cadeira]
      end

      it 'should return an empty array when there are no purchase_solicitation_item_group_materials' do
        expect(subject.purchase_solicitation_items).to eq []
      end
    end

    describe '#purchase_solicitation_item_ids' do
      before do
        subject.stub(:purchase_solicitation_item_group_materials).
                and_return(purchase_solicitation_item_group_materials)
      end

      it 'should return items_ids from purchase_solicitation_item_group_material' do
        purchase_solicitation_item_group_materials << purchase_solicitation_item_group_material1
        purchase_solicitation_item_group_materials << purchase_solicitation_item_group_material2

        subject.stub(:purchase_solicitation_item_group_materials).
                and_return(purchase_solicitation_item_group_materials)

        expect(subject.purchase_solicitation_item_ids).to eq [1, 2, 3]
      end

      it 'should return an empty array when there are no purchase_solicitation_item_group_materials' do
        subject.stub(:purchase_solicitation_item_group_materials).
                and_return(purchase_solicitation_item_group_materials)

        expect(subject.purchase_solicitation_item_ids).to eq []
      end
    end
  end

  describe "#change_status!" do
    it "changes the status of the group" do
      subject.should_receive(:update_column).with(:status, 'foo')
      subject.change_status!('foo')
    end
  end

  describe "#fulfill!" do
    it "changes the status to 'FULFILLED'" do
      subject.should_receive(:update_column).with(:status, 'fulfilled')
      subject.fulfill!
    end
  end

  context 'with purchase solicitations' do
    let(:purchase1) { double(:purchase1) }
    let(:purchase2) { double(:purchase2) }

    describe '#liberate_purchase_solicitations!' do
      it "should the status_service for all purchase_solicitations to 'liberated'" do
        subject.stub(:purchase_solicitations).and_return([purchase1, purchase2])

        purchase1.should_receive(:liberate!)
        purchase2.should_receive(:liberate!)

        subject.liberate_purchase_solicitations!
      end
    end

     describe '#buy_purchase_solicitations!' do
      it "should the status_service for all purchase_solicitations to 'in_purchase_process'" do
        subject.stub(:purchase_solicitations).and_return([purchase1, purchase2])

        purchase1.should_receive(:buy!)
        purchase2.should_receive(:buy!)

        subject.buy_purchase_solicitations!
      end
    end
  end

  describe '#attend_items!' do
    it "should change status of items to 'attended'" do
      item1 = double(:item1)
      item2 = double(:item2)

      subject.stub(:purchase_solicitation_items).and_return([item1, item2])

      item1.should_receive(:attend!)
      item2.should_receive(:attend!)

      subject.attend_items!
    end
  end

  describe '#rollback_attended_items!' do
    it "should change status of items to 'pending'" do
      item1 = double(:item1)
      item2 = double(:item2)

      subject.stub(:purchase_solicitation_items).and_return([item1, item2])

      item1.should_receive(:pending!)
      item2.should_receive(:pending!)

      subject.rollback_attended_items!
    end
  end
end
