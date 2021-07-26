class ChangeCheckingAccountStructuresFieldsToText < ActiveRecord::Migration
  def change
    change_table :compras_checking_account_structures do |t|
      t.change :description, :text
      t.change :fill, :text
      t.change :reference, :text
    end
  end
end
