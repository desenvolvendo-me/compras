# encoding: utf-8
require 'model_helper'
require 'app/models/price_collection_classification'

describe PriceCollectionClassification do
  it { should belong_to :price_collection_proposal }
  it { should belong_to :classifiable }

  context '#disqualified' do
    it 'should be false' do
      subject.classification = 1

      expect(subject.disqualified?).to be false
    end

    it 'should be true' do
      subject.classification = -1

      expect(subject.disqualified?).to be true
    end
  end
end
