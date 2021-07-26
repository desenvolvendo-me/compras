CompanySize.blueprint(:micro_empresa) do
  name { "Microempresa" }
  acronym { "ME" }
  number { "1" }
  extended_company_size { ExtendedCompanySize.make!(:micro_empresa, :company_size => object) }
end

CompanySize.blueprint(:empresa_de_grande_porte) do
  name { "Empresa de grande porte" }
  acronym { "EGP" }
  number { "3" }
  extended_company_size { ExtendedCompanySize.make!(:empresa_de_grande_porte, :company_size => object) }
end
