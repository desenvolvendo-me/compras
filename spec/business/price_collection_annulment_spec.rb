require 'unit_helper'
require 'app/business/price_collection_annulment'

describe PriceCollectionAnnulment do
  let :price_collection do
    double('PriceCollection', :price_collection_proposals => [proposal])
  end

  let :annul do
    double('Annul', :date => 'current date', :description => 'Foo Bar', :employee_id => 1)
  end

  let :proposal do
    double('Proposal')
  end

  subject{ described_class.new(price_collection) }

  it 'should not annul the proposal when annul is not present' do
    price_collection.should_not_receive(:annul!)
    price_collection.stub_chain(:annul, :present?).and_return false

    subject.change!
  end

  it 'should annul the proposal when annul is present' do
    price_collection.should_receive(:annul!).and_return true
    price_collection.stub(:annul).and_return annul
    price_collection.stub_chain(:annul, :present?).and_return true

    proposal.should_receive(:annul!)
    proposal.should_receive(:build_annul).with(:employee_id => 1, :date => 'current date', :description => 'Foo Bar').and_return double(:save => true)

    subject.change!
  end
end
