class CreateLicitationCommissionResponsibles < ActiveRecord::Migration
  def change
    create_table :licitation_commission_responsibles do |t|
      t.references :licitation_commission
      t.references :individual
      t.string :role
      t.string :class_register

      t.timestamps
    end

    add_index :licitation_commission_responsibles, :licitation_commission_id, :name => "lcr_licitation_commission_id"
    add_index :licitation_commission_responsibles, :individual_id, :name => "lcr_individual_id"
    add_foreign_key :licitation_commission_responsibles, :licitation_commissions, :name => "lcr_licitation_commission_fk"
    add_foreign_key :licitation_commission_responsibles, :individuals, :name => "lcr_individual_kf"
  end
end
