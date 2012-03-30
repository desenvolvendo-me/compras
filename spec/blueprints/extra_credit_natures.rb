# encoding: utf-8
ExtraCreditNature.blueprint(:abre_credito) do
  description { "Abre crédito suplementar" }
  kind { ExtraCreditNatureKind::OTHER }
end

ExtraCreditNature.blueprint(:abre_credito_de_transferencia) do
  description { "Abre crédito suplementar de transferência" }
  kind { ExtraCreditNatureKind::TRANSFER }
end
