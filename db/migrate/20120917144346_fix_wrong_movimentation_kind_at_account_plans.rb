class FixWrongMovimentationKindAtAccountPlans < ActiveRecord::Migration
  class AccountPlan < Compras::Model
  end

  def change
    AccountPlan.where(:movimentation_kind => 'unilaterial_creditor').update_all(:movimentation_kind => 'unilateral_creditor')
  end
end
