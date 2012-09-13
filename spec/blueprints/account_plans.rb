# encoding: utf-8
AccountPlan.blueprint(:bancos) do
  account_plan_configuration { AccountPlanConfiguration.make!(:plano1) }
  checking_account { '9.99' }
  title { 'Bancos conta movimento' }
  function { 'Registra a movimentação' }
end
