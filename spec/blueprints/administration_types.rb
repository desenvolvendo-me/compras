# encoding: utf-8
AdministrationType.blueprint(:publica) do
  code { "01" }
  name { "Pública" }
  administration { "direct" }
  organ_type { "public_foundation" }
  legal_nature { LegalNature.make!(:administracao_publica) }
end
