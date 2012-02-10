# encoding: utf-8
AdministrationType.blueprint(:publica) do
  description { "Pública" }
  administration { "direct" }
  organ_type { "public_foundation" }
  legal_nature { LegalNature.make!(:administracao_publica) }
end

AdministrationType.blueprint(:executivo) do
  description { "Executivo" }
  administration { "direct" }
  organ_type { "public_foundation" }
  legal_nature { LegalNature.make!(:executivo_federal) }
end
