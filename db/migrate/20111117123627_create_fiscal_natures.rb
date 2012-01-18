class CreateFiscalNatures < ActiveRecord::Migration
  def change
    create_table :fiscal_natures do |t|
      t.string :name
      t.string :incidence

      t.timestamps
    end
  end
end
