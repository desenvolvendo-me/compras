CheckingAccountStructureInformation.blueprint(:fonte_de_recursos) do
  name { "Fonte de Recursos" }
  tce_code { 1 }
  referenced_table { 'Tabela fonte de recursos' }
end

CheckingAccountStructureInformation.blueprint(:outras_fontes) do
  name { "Outras Fontes" }
  tce_code { 3 }
  referenced_table { 'Tabela fonte de recursos' }
end
