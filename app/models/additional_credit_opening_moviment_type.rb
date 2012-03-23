class AdditionalCreditOpeningMovimentType < ActiveRecord::Base
  attr_accessible :moviment_type_id, :budget_allocation_id, :capability_id, :value

  belongs_to :moviment_type
  belongs_to :budget_allocation
  belongs_to :capability

  validates :moviment_type, :value, :presence => true
  validates :budget_allocation, :presence => true, :if => :moviment_type_as_budget_allocation?
  validates :capability, :presence => true, :if => :moviment_type_as_capability?
  validates :budget_allocation_id, :uniqueness => { :scope => [:additional_credit_opening_id] }, :allow_blank => true
  validates :capability_id, :uniqueness => { :scope => [:additional_credit_opening_id] }, :allow_blank => true

  def moviment_type_as_budget_allocation?
    return unless moviment_type

    moviment_type.budget_allocation?
  end

  def moviment_type_as_capability?
    return unless moviment_type

    moviment_type.capability?
  end
end
