AdditionalCreditOpening.blueprint(:detran_2012) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  credit_type { AdditionalCreditOpeningCreditType::SPECIAL }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  additional_credit_opening_nature { AdditionalCreditOpeningNature.make!(:abre_credito) }
  additional_credit_opening_moviment_types { [
    AdditionalCreditOpeningMovimentType.make(:adicionar_dotacao),
    AdditionalCreditOpeningMovimentType.make(:subtrair_do_excesso_arrecadado)
  ] }
  credit_date { Date.new(2012, 3, 1) }
end
