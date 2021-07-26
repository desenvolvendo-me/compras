class AddColumnIssuanceDateToJudgementCommissionAdvices < ActiveRecord::Migration
  def change
    add_column :compras_judgment_commission_advices, :issuance_date, :date
  end
end
