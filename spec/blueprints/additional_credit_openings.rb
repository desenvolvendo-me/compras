AdditionalCreditOpening.blueprint(:detran_2012) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  credit_type { AdditionalCreditOpeningCreditType::SPECIAL }
  administractive_act { AdministractiveAct.make!(:sopa) }
  additional_credit_opening_nature { AdditionalCreditOpeningNature.make!(:abre_credito) }
  credit_date { '01/03/2012' }
end
