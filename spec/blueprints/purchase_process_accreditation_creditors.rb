PurchaseProcessAccreditationCreditor.blueprint(:sobrinho_creditor) do
  creditor { Creditor.make!(:sobrinho_sa) }
  company_size { CompanySize.make!(:empresa_de_grande_porte) }
  has_power_of_attorney { true }
end

PurchaseProcessAccreditationCreditor.blueprint(:wenderson_creditor) do
  creditor { Creditor.make!(:wenderson_sa) }
  company_size { CompanySize.make!(:empresa_de_grande_porte) }
  has_power_of_attorney { true }
end
