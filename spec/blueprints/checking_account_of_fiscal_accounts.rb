# encoding: utf-8
CheckingAccountOfFiscalAccount.blueprint(:disponibilidade_financeira) do
  tce_code { 14 }
  name { "Disponibilidade financeira" }
  main_tag { "DisponibilidadeFinanceira" }
  function { "Detalhar as movimentações financeiras" }
end

CheckingAccountOfFiscalAccount.blueprint(:disponibilidade) do
  tce_code { 30 }
  name { "Disponibilidade" }
  main_tag { "Disponibilidade" }
  function { "Detalhar as todas as movimentações" }
end
