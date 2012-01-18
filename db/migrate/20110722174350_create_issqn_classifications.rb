class CreateIssqnClassifications < ActiveRecord::Migration
  def change
    create_table :issqn_classifications do |t|
      t.string :name

      t.timestamps
    end
  end
end
