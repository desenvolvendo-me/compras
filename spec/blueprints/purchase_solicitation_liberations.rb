# encoding: utf-8
PurchaseSolicitationLiberation.blueprint(:reparo) do
  date { Date.today }
  responsible { Employee.make!(:sobrinho) }
  justification { "Reparo nas instalações" }
  service_status { PurchaseSolicitationServiceStatus::LIBERATED }
end
