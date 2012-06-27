# encoding: utf-8
DeliverySchedule.blueprint(:primeira_entrega) do
  sequence { 1 }
  scheduled_date { Date.new(2012, 1, 1) }
  delivery_date { Date.new(2012, 1, 2) }
  contract { Contract.make!(:primeiro_contrato) }
  delivery_schedule_status { DeliveryScheduleStatus::DELIVERED }
  observations { "entregue com atraso" }
end
