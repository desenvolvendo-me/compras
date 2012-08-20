# encoding: utf-8
CapabilitySource.blueprint(:imposto) do
  code { 1 }
  name { "Imposto" }
  specification { "Especificação" }
  source { Source::MANUAL }
end

CapabilitySource.blueprint(:transferencia) do
  code { 2 }
  name { "Transferência" }
  specification { "Entre convênios" }
  source { Source::MANUAL }
end
