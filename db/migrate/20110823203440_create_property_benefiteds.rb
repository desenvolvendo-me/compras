class CreatePropertyBenefiteds < ActiveRecord::Migration
  def change
    create_table :property_benefiteds do |t|
      t.references :contribution_improvement
      t.references :property
      t.decimal :base_value1, :precision => 10, :scale => 2
      t.decimal :base_value2, :precision => 10, :scale => 2
      t.decimal :base_value3, :precision => 10, :scale => 2
      t.decimal :base_value4, :precision => 10, :scale => 2
      t.boolean :agreement, :default => false
      t.date :agreement_date
      t.integer :number_of_plots
      t.date :first_due_date
      t.integer :range_due_dates

      t.timestamps
    end
    add_index :property_benefiteds, :contribution_improvement_id
    add_index :property_benefiteds, :property_id
    add_foreign_key :property_benefiteds, :contribution_improvements
    add_foreign_key :property_benefiteds, :properties
  end
end
