AccountPlanConfiguration.blueprint(:plano1) do
  year { 2012 }
  state { State.make!(:mg) }
  description { "Plano1" }
  account_plan_levels { [
    AccountPlanLevel.make!(:orgao),
    AccountPlanLevel.make!(:unidade)
  ] }
end

AccountPlanConfiguration.blueprint(:segundo_plano) do
  year { 2011 }
  state { State.make!(:mg) }
  description { 'Segundo plano de MG' }
  account_plan_levels { [
    AccountPlanLevel.make!(:primeiro_nivel_com_ponto),
    AccountPlanLevel.make!(:segundo_nivel_com_ponto)
  ] }
end
