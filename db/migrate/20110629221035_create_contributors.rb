class CreateContributors < ActiveRecord::Migration
  def change
    create_table :contributors do |t|
      t.string :name
      t.references :personable, :polymorphic => true

      t.timestamps
    end
    add_index :contributors, :personable_id
    add_index :contributors, :personable_type
  end
end
