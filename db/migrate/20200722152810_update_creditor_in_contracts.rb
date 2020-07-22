class UpdateCreditorInContracts < ActiveRecord::Migration
  def up
    execute <<-SQL
      with t as (
        select t1.creditor_id as creditor_id, t1.contract_id as contract_id
        from compras_contracts_unico_creditors as t1
      )
      update compras_contracts
      set creditor_id = t.creditor_id
      from t
      where id = t.contract_id
    SQL
  end
end
