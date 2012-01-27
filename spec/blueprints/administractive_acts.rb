AdministractiveAct.blueprint(:sopa) do
  act_number { "01" }
  type_of_administractive_act { TypeOfAdministractiveAct.make!(:lei) }
  text_legal_nature { "natureza" }
  creation_date { "01/01/2012" }
  publication_date { "02/01/2012" }
  vigor_date { "03/01/2012" }
  end_date { "09/01/2012" }
  content { "conteudo" }
  budget_law_percent { "5,00" }
  revenue_antecipation_percent { "3,00" }
  authorized_debt_value { "7000,00" }
end
