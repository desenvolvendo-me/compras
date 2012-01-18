class CreateAgreementMovements < ActiveRecord::Migration
  def change
    create_table :agreement_movements do |t|
      t.references :agreement
      t.references :movementable, :polymorphic => true

      t.timestamps
    end
    add_index :agreement_movements, :agreement_id
    add_index :agreement_movements, [:movementable_id, :movementable_type], :name => "index_agreement_movements_on_movementable"
    add_foreign_key :agreement_movements, :agreements
  end
end
