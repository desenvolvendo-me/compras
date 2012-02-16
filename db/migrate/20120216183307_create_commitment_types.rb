class CreateCommitmentTypes < ActiveRecord::Migration
  def change
    create_table :commitment_types do |t|
      t.integer :code
      t.string :description

      t.timestamps
    end
  end
end
