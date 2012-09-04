AccountPlanConfiguration.blueprint(:plano1) do
  year { 2012 }
  state { State.make!(:mg) }
  description { "Plano1" }
end
