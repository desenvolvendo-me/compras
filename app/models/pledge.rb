class Pledge < ActiveRecord::Base
  attr_accessible :entity_id, :year, :management_unit_id, :emission_date, :commitment_type_id,
                  :budget_allocation_id, :value, :pledge_category_id

  orderize :emission_date
  filterize

  delegate :amount, :function, :subfunction, :government_program, :government_action, :organogram, :expense_economic_classification,
           :to => :budget_allocation, :allow_nil => true, :prefix => true

  belongs_to :entity
  belongs_to :management_unit
  belongs_to :commitment_type
  belongs_to :budget_allocation
  belongs_to :pledge_category

  validates :year, :mask => '9999'
  validates :emission_date, :timeliness => { :on_or_after => Date.current, :type => :date }

  def to_s
    id.to_s
  end
end
