class PriceCollectionsProvider < ActiveRecord::Base
  belongs_to :price_collection
  belongs_to :provider
end
