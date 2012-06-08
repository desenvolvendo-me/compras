class PriceCollectionProposalAnnul < ActiveRecord::Base
  belongs_to :price_collection_proposal
  belongs_to :employee
  attr_accessible :date, :description, :employee_id

  validates :date, :employee, :price_collection_proposal, :presence => true

  delegate :provider, :price_collection, :to => :price_collection_proposal
end
