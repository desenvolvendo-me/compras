# encoding: utf-8
RegularizationOrAdministrativeSanctionReason.blueprint(:sancao_administrativa) do
  description { "Advertência por desistência parcial da proposta devidamente justificada" }
  reason_type { RegularizationOrAdministrativeSanctionReasonType::ADMINISTRATIVE_SANCTION }
end

RegularizationOrAdministrativeSanctionReason.blueprint(:regularizacao) do
  description { "Ativação do registro cadastral" }
  reason_type { RegularizationOrAdministrativeSanctionReasonType::REGULARIZATION }
end
