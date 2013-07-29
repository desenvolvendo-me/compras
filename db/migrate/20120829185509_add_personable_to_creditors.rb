class AddPersonableToCreditors < ActiveRecord::Migration
  def change
    add_column :compras_creditors, :creditable_id, :integer
    add_column :compras_creditors, :creditable_type, :string

    remove_column :compras_creditors, :person_id

    add_index :compras_creditors, [:creditable_id, :creditable_type], :name => :cc_classifiable
  end
end
