class RemoveSomeFieldsFromLicitationProcesses < ActiveRecord::Migration
  def change
    change_table(:compras_licitation_processes) do |t|
      t.remove :legal_advice
      t.remove :legal_advice_date
      t.remove :contract_date
      t.remove :contract_expiration
      t.remove :observations
    end
  end
end
