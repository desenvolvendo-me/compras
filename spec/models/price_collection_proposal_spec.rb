require 'model_helper'
require 'app/models/price_collection_proposal'
require 'app/models/price_collection_proposal_item'
require 'lib/annullable'
require 'app/models/resource_annul'
require 'app/models/price_collection_classification'
require 'app/models/employee'

describe PriceCollectionProposal do
  it { should belong_to :price_collection }
  it { should belong_to :creditor }
  it { should belong_to :employee }

  it { should have_many :items }
  it { should have_many :price_collection_classifications }
  it { should have_one :annul }

  it { should validate_presence_of :creditor }

  it { should delegate(:code).to(:price_collection).prefix(true).allowing_nil(true) }
  it { should delegate(:year).to(:price_collection).prefix(true).allowing_nil(true) }

  xit 'should return price_colletion and creditor as to_s method' do
    subject.stub(:price_collection).and_return('Price Collection 1')
    subject.stub(:creditor).and_return('creditor 1')

    expect(subject.to_s).to eq 'Price Collection 1 - creditor 1'
  end

  describe '#build_user' do
    context 'has a user' do
      before do
        subject.stub(:user).and_return user
        subject.stub_chain(:user, :present?).and_return true
      end

      let :user do
        double('user')
      end

      xit 'should return the user' do
        expect(subject.build_user).to eq user
      end
    end

    context 'has no user' do
      before do
        subject.stub_chain(:user, :present?).and_return false
        subject.stub(:creditor).and_return creditor
      end

      let :creditor do
        double('Creditor')
      end

      xit 'delegates to the creditor to build the user' do
        creditor.should_receive(:build_user)

        subject.build_user
      end
    end
  end

  context 'items by lot' do
    let(:price_collection_item_1) { double(:price_collection_item, lot: 'lot 1') }
    let(:price_collection_item_2) { double(:price_collection_item, lot: 'lot 2') }
    let(:price_collection_item_3) { double(:price_collection_item, lot: 'lot 1') }

    let(:item_1) do
      double('item 1', :lot => 'lot 1', :total_price => 10,
        price_collection_item: price_collection_item_1)
    end

    let(:item_2) do
      double('item 2', :lot => 'lot 2', :total_price => 20,
        price_collection_item: price_collection_item_2)
    end

    let(:item_3) do
      double('item 3', :lot => 'lot 1', :total_price => 40,
        price_collection_item: price_collection_item_3)
    end

    xit 'should return the items by lot' do
      subject.stub(:items).and_return([item_1, item_2, item_3])

      expect(subject.items_by_lot('lot 1')).to eq [item_1, item_3]
    end

    xit 'should return the item total value by lot' do
      subject.stub(:items).and_return([item_1, item_2, item_3])

      expect(subject.item_total_value_by_lot('lot 1')).to eq 50
    end
  end

  describe '#editable_by?' do
    let(:creditor) { double :creditor }
    let(:employee) { Employee.new }

    before { subject.stub(creditor: creditor) }

    xit 'is true when the creditor is the given user' do
      user = double('User', authenticable: creditor)

      expect(subject.editable_by?(user)).to be_true
    end

    xit 'is true when the given user is a employee' do
      user = double('User', authenticable: employee)

      expect(subject.editable_by?(user)).to be_true
    end

    xit 'is false when the creditor or employee is not the given user' do
      user = double('User', authenticable: double)

      expect(subject.editable_by?(user)).to be_false
    end
  end

  describe '#annul!' do
    it 'should change the subject status to annuled' do
      subject.should_receive(:update_column).with(:status, PriceCollectionStatus::ANNULLED)

      subject.annul!
    end
  end

  it 'should return 0 as the total price when there are no items' do
    expect(subject.total_price).to eq 0
  end

  xit 'should return the total price' do
    item_1 = double('item 1', :total_price => 300)
    item_2 = double('item 2', :total_price => 200)

    subject.stub(:items).and_return([item_1, item_2])

    expect(subject.total_price).to eq 500
  end

  context 'item with unit price equals zero' do
    xit 'should return true' do
      subject.stub(:items => double(:any_without_unit_price? => true))

      expect(subject.has_item_with_unit_price_equals_zero).to be true
    end

    xit 'should return false' do
      subject.stub(:items => double(:any_without_unit_price? => false))

      expect(subject.has_item_with_unit_price_equals_zero).to be false
    end
  end
end
