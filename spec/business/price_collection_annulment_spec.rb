require 'unit_helper'
require 'app/business/price_collection_annulment'

describe PriceCollectionAnnulment do
  let :price_collection do
    double('PriceCollection', :price_collection_proposals => [proposal])
  end

  let :annul do
    double('Annul', :date => 'current date', :description => 'Foo Bar', :employee_id => 1, :present? => true)
  end

  let :proposal do
    double('Proposal')
  end

  let :proposal_annulment do
    double('ProposalAnnulment')
  end

  subject{ described_class.new(price_collection, proposal_annulment) }

  it 'should not annul the proposal when annul is not present' do
    price_collection.should_not_receive(:annul!)
    price_collection.stub_chain(:annul, :present?).and_return(false)

    subject.change!
  end

  it 'should annul the proposal when annul is present' do
    price_collection.should_receive(:annul!).and_return(true)
    price_collection.stub(:annul).and_return(annul)

    proposal_annulment.should_receive(:annul_proposals!).with([proposal], annul)

    subject.change!
  end
end
