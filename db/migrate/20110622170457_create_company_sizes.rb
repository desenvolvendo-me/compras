class CreateCompanySizes < ActiveRecord::Migration
  def change
    create_table :company_sizes do |t|
      t.string :name
      t.string :acronym
      t.string :number

      t.timestamps
    end
  end
end
