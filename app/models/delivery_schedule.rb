class DeliverySchedule < Compras::Model
  attr_accessible :delivery_date, :delivery_schedule_status, :observations, :scheduled_date, :contract_id

  has_enumeration_for :delivery_schedule_status

  belongs_to :contract

  before_create :set_code

  def next_code
    last_code.succ
  end

  protected

  def set_code
    self.sequence = next_code
  end

  def last_code
    self.class.where { self.contract_id.eq(contract_id) }.maximum(:sequence).to_i
  end
end
