class ChangeContactInLicitationProcess < ActiveRecord::Migration
  def up
    add_column :compras_licitation_processes, :contact, :string

    execute <<-SQL
      with t as (
        select t4.name, t1.id as licitation_id
        from compras_licitation_processes as t1
        inner join compras_employees as t2 on t1.contact_id = t2.id
        inner join unico_individuals as t3 on t2.individual_id = t3.id
        inner join unico_people as t4 on t3.id = t4.personable_id and t4.personable_type = 'Individual'
      )
      update compras_licitation_processes
      set contact = t.name
      from t
      where id = t.licitation_id
    SQL

    remove_column :compras_licitation_processes, :contact_id
  end
end
