ExtraCredit.blueprint(:detran_2012) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  credit_type { ExtraCreditKind::SPECIAL }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  additional_credit_opening_nature { AdditionalCreditOpeningNature.make!(:abre_credito) }
  extra_credit_moviment_types { [
    ExtraCreditMovimentType.make(:adicionar_dotacao),
    ExtraCreditMovimentType.make(:subtrair_do_excesso_arrecadado)
  ] }
  credit_date { Date.new(2012, 3, 1) }
end
