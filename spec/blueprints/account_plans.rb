# encoding: utf-8
AccountPlan.blueprint(:bancos) do
  account_plan_configuration { AccountPlanConfiguration.make!(:plano1) }
  checking_account { '9.99' }
  title { 'Bancos conta movimento' }
  function { 'Registra a movimentação' }
  nature_balance { NatureBalance::DEBT }
  bookkeeping { true }
  nature_information { NatureInformation::PATRIMONIAL }
  surplus_indicator { SurplusIndicator::FINANCIAL }
  nature_balance_variation { NatureBalanceVariation::REVERSE_BALANCE }
  movimentation_kind { MovimentationKind::BILATERAL }
  detailing_required_opening { true }
end
