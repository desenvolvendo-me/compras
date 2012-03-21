class CreateAdditionalCreditOpeningNatures < ActiveRecord::Migration
  def change
    create_table :additional_credit_opening_natures do |t|
      t.string :description
      t.string :kind

      t.timestamps
    end
  end
end
