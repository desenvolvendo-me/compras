require 'model_helper'
require 'lib/annullable'
require 'app/models/price_collection'
require 'app/models/price_collection_annul'

describe PriceCollectionAnnul do
  it { should belong_to :price_collection }
  it { should belong_to :employee }

  it { should validate_presence_of :price_collection }
end
