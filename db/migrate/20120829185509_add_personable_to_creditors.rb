class AddPersonableToCreditors < ActiveRecord::Migration
  def change
    add_column :compras_creditors, :creditable_id, :integer
    add_column :compras_creditors, :creditable_type, :string

    Creditor.where { person_id.not_eq(nil) }.each do |creditor|
      creditor.update_column :creditable_id, creditor.person_id
      creditor.update_column :creditable_type, 'Person'
    end

    remove_column :compras_creditors, :person_id

    add_index :compras_creditors, [:creditable_id, :creditable_type], :name => :cc_classifiable
  end
end
