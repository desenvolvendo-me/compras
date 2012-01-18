class AddingForeignKeysToFiscalActions < ActiveRecord::Migration
  def change
    add_foreign_key :fiscal_actions, :economic_registrations
    add_foreign_key :fiscal_actions, :fiscal_programmings
  end
end
