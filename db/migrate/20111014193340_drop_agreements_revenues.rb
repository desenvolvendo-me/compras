class DropAgreementsRevenues < ActiveRecord::Migration
  def change
    drop_table :agreements_revenues
  end
end
