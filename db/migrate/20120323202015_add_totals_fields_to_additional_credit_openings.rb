class AddTotalsFieldsToAdditionalCreditOpenings < ActiveRecord::Migration
  def change
    change_table :additional_credit_openings do |t|
      t.decimal :supplement, :precision => 10, :scale => 2
      t.decimal :reduced, :precision => 10, :scale => 2
    end
  end
end
