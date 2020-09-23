class ChangeLawyerColumnToContracts < ActiveRecord::Migration
  def change
    rename_column :compras_contracts, :lawyer_id, :lawyer_id_old
    add_column :compras_contracts, :lawyer_name, :string

    execute <<-SQL
      with t as (
        select p1.id, up.name
        from compras_employees as p1
        inner join unico_individuals ui on p1.individual_id = ui.id
        inner join unico_people as up on up.personable_id = ui.id and up.personable_type = 'Individual'
      )

      update compras_contracts
      set lawyer_name = t.name
      from t
      where compras_contracts.lawyer_id_old = t.id
    SQL
  end
end
