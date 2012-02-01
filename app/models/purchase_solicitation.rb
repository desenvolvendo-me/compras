class PurchaseSolicitation < ActiveRecord::Base
  attr_accessible :accounting_year, :request_date, :responsible_id, :justification, :budget_allocation_id,
                  :delivery_location_id, :kind, :general_observations

  attr_protected :allocation_amount, :service_status, :liberation_date, :liberator, :service_observations,
                 :no_service_justification, :responsible, :liberator_id, :budget_allocation, :delivery_location

  belongs_to :responsible, :class_name => 'Employee', :foreign_key => 'responsible_id'
  belongs_to :budget_allocation
  belongs_to :delivery_location
  belongs_to :liberator, :class_name => 'Employee', :foreign_key => 'liberator_id'

  validates :accounting_year, :request_date, :budget_allocation_id, :responsible_id,
            :delivery_location, :kind, :delivery_location_id, :presence => true

  before_create :set_status_to_pending

  orderize :request_date
  filterize

  has_enumeration_for :kind, :with => PurchaseSolicitationKind, :create_helpers => true
  has_enumeration_for :service_status, :with => PurchaseSolicitationServiceStatus, :create_helpers => true

  def to_s
    justification
  end

  protected

  def set_status_to_pending
    self.service_status = 'pending'
  end
end
