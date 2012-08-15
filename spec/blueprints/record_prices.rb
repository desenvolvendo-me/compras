# encoding: utf-8
RecordPrice.blueprint(:registro_de_precos) do
  number { 1 }
  year { 2012 }
  date { Date.new(2012, 4, 5) }
  validaty_date { Date.new(2013, 4, 5) }
  situation { RecordPriceSituation::ACTIVE }
  licitation_process { LicitationProcess.make(:processo_licitatorio) }
  description { "Aquisição de combustíveis" }
  delivery_location { DeliveryLocation.make(:education) }
  management_unit { ManagementUnit.make(:unidade_central) }
  responsible { Employee.make(:sobrinho) }
  payment_method { PaymentMethod.make(:dinheiro) }
  delivery { 1 }
  delivery_unit { PeriodUnit::YEAR }
  validity { 1 }
  validaty_unit { PeriodUnit::YEAR  }
  observations { "Aquisição de combustíveis" }
end
