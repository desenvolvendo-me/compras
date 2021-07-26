class DeliverySchedule < Compras::Model
  attr_accessible :delivery_date, :delivery_schedule_status, :observations,
                  :scheduled_date, :contract_id

  attr_readonly :sequence

  auto_increment :sequence, :by => :contract_id

  has_enumeration_for :delivery_schedule_status

  belongs_to :contract
end
