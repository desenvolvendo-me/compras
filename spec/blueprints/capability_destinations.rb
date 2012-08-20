# encoding: utf-8
CapabilityDestination.blueprint(:linha_de_credito) do
  use { CapabilityDestinationUse::DONATIONS }
  group { CapabilityDestinationGroup::CONDITIONAL }
  specification { 1 }
  description { "Programa de linha de crédito" }
  kind { CapabilityDestinationKind::PRIMARY }
end
