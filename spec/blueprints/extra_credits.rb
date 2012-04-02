ExtraCredit.blueprint(:detran_2012) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  credit_type { ExtraCreditKind::SPECIAL }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  extra_credit_nature { ExtraCreditNature.make!(:abre_credito) }
  extra_credit_moviment_types { [
    ExtraCreditMovimentType.make(:adicionar_dotacao),
    ExtraCreditMovimentType.make(:subtrair_do_excesso_arrecadado)
  ] }
  credit_date { Date.new(2012, 3, 1) }
end
