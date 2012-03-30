class ExtraCreditMovimentType < ActiveRecord::Base
  attr_accessible :moviment_type_id, :budget_allocation_id, :capability_id, :value

  belongs_to :moviment_type
  belongs_to :budget_allocation
  belongs_to :capability

  validates :moviment_type, :value, :presence => true
  validates :budget_allocation, :presence => true, :if => :moviment_type_as_budget_allocation?
  validates :capability, :presence => true, :if => :moviment_type_as_capability?
  validates :budget_allocation_id, :uniqueness => { :scope => [:extra_credit_id] }, :allow_blank => true
  validates :capability_id, :uniqueness => { :scope => [:extra_credit_id] }, :allow_blank => true

  delegate :budget_allocation?, :subtration?, :to => :moviment_type, :allow_nil => true
  delegate :operation, :to => :moviment_type, :allow_nil => true
  delegate :real_amount, :to => :budget_allocation, :prefix => true, :allow_nil => true

  def moviment_type_as_budget_allocation?
    moviment_type.try(:budget_allocation?)
  end

  def moviment_type_as_capability?
    moviment_type.try(:capability?)
  end
end
