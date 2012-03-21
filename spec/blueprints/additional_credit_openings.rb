AdditionalCreditOpening.blueprint(:detran_2012) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  credit_type { AdditionalCreditOpeningCreditType::SPECIAL }
end
