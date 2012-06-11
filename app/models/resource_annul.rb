class ResourceAnnul < ActiveRecord::Base
  include Annullable
  belongs_to :resource, :polymorphic => true

  validates :resource, :presence => true

  delegate :provider, :price_collection, :to => :resource, :allow_nil => true
end
