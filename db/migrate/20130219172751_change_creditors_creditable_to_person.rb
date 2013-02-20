class ChangeCreditorsCreditableToPerson < ActiveRecord::Migration
  def change
    remove_index :compras_creditors, :column => [:creditable_id, :creditable_type]

    execute <<-SQL
    update
      compras_creditors
    set
      creditable_id = NULL
    where
      creditable_type = 'SpecialEntry';
    SQL

    remove_column :compras_creditors, :creditable_type
    rename_column :compras_creditors, :creditable_id, :person_id

    add_index :compras_creditors, :person_id
    add_foreign_key :compras_creditors, :unico_people, :column => :person_id

    drop_table :compras_special_entries
  end
end
