class CreateBranchClassifications < ActiveRecord::Migration
  def change
    create_table :branch_classifications do |t|
      t.string :name

      t.timestamps
    end
  end
end
