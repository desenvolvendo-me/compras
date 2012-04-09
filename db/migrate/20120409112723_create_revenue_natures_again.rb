class CreateRevenueNaturesAgain < ActiveRecord::Migration
  def change
    create_table :revenue_natures do |t|
      t.references :regulatory_act
      t.string :classification
      t.references :revenue_rubric
      t.string :specification
      t.string :kind
      t.text :docket

      t.timestamps
    end

    add_index :revenue_natures, :regulatory_act_id
    add_index :revenue_natures, :revenue_rubric_id

    add_foreign_key :revenue_natures, :regulatory_acts
    add_foreign_key :revenue_natures, :revenue_rubrics
  end
end
