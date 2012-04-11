class CreateLicitationCommissionMembers < ActiveRecord::Migration
  def change
    create_table :licitation_commission_members do |t|
      t.references :licitation_commission
      t.references :individual
      t.string :role
      t.string :role_nature
      t.string :registration

      t.timestamps
    end

    add_index :licitation_commission_members, :licitation_commission_id, :name => 'lcm_licitation_commission_id'
    add_index :licitation_commission_members, :individual_id, :name => 'lcm_individual_id'

    add_foreign_key :licitation_commission_members, :licitation_commissions, :name => 'lcm_licitation_commission_fk'
    add_foreign_key :licitation_commission_members, :individuals, :name => 'lcm_individual_fk'
  end
end
