# encoding: utf-8
AdditionalCreditOpeningNature.blueprint(:abre_credito) do
  description { "Abre crédito suplementar" }
  kind { AdditionalCreditOpeningNatureKind::OTHER }
end

AdditionalCreditOpeningNature.blueprint(:abre_credito_de_transferencia) do
  description { "Abre crédito suplementar de transferência" }
  kind { AdditionalCreditOpeningNatureKind::TRANSFER }
end
