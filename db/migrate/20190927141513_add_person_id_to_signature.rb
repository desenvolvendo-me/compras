class AddPersonIdToSignature < ActiveRecord::Migration
  def change
    add_column :compras_signatures, :person_id,
               :integer

    add_index :compras_signatures, :person_id
    add_foreign_key :compras_signatures, :unico_people,
                    column: :person_id
  end
end
