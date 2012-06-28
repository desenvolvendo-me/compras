# encoding: utf-8
ResourceAnnul.blueprint(:rescisao_de_contrato_anulada) do
  date { Date.new(2012, 06, 28) }
  employee { Employee.make!(:sobrinho) }
  description { "Rescisão Anulada" }
  annullable { ContractTermination.make!(:contrato_rescindido) }
end
