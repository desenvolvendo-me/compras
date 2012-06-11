class ResourceAnnul < ActiveRecord::Base
  belongs_to :resource, :polymorphic => true
  belongs_to :employee
  attr_accessible :date, :description, :employee_id

  validates :date, :employee, :resource, :presence => true

  delegate :provider, :price_collection, :to => :resource, :allow_nil => true
end
