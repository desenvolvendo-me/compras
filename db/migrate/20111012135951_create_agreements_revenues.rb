class CreateAgreementsRevenues < ActiveRecord::Migration
  def change
    create_table :agreements_revenues, :id => false do |t|
      t.references :agreement, :revenue
    end

    add_index :agreements_revenues, :agreement_id
    add_index :agreements_revenues, :revenue_id
    add_index :agreements_revenues, [:revenue_id, :agreement_id]
    add_foreign_key :agreements_revenues, :revenues
    add_foreign_key :agreements_revenues, :agreements
  end
end
