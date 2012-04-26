class AddAdviceFieldsToJudgmentCommissionAdvice < ActiveRecord::Migration
  def change
    add_column :judgment_commission_advices, :judgment_start_date, :date
    add_column :judgment_commission_advices, :judgment_start_time, :time
    add_column :judgment_commission_advices, :judgment_end_date, :date
    add_column :judgment_commission_advices, :judgment_end_time, :time
    add_column :judgment_commission_advices, :companies_minutes, :text
    add_column :judgment_commission_advices, :companies_documentation_minutes, :text
    add_column :judgment_commission_advices, :justification_minutes, :text
    add_column :judgment_commission_advices, :judgment_minutes, :text
  end
end
