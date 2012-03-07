# encoding: utf-8
BidOpening.blueprint(:compra_de_cadeiras) do
  process { 1 }
  year { 2012 }
  date { '2012-03-07' }
  protocol { '00099/2012' }
  organogram { Organogram.make!(:secretaria_de_educacao) }
  value_estimated { "500,50" }
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  modality { BidOpeningModality::AUCTION }
  object_type { BidOpeningObjectType::PURCHASE_AND_SERVICES }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  bid_opening_status { BidOpeningStatus::WAITING }
  delivery_date { '2012-03-07' }
end
