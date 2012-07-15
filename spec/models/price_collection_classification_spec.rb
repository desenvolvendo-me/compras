# encoding: utf-8
require 'model_helper'
require 'app/models/price_collection_classification'

describe PriceCollectionClassification do
    it { should belong_to :creditor }
    it { should belong_to :classifiable }
end
