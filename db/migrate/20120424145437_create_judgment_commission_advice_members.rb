class CreateJudgmentCommissionAdviceMembers < ActiveRecord::Migration
  def change
    create_table :judgment_commission_advice_members do |t|
      t.references :judgment_commission_advice
      t.references :individual
      t.string :role
      t.string :role_nature
      t.string :registration

      t.timestamps
    end

    add_index :judgment_commission_advice_members, :judgment_commission_advice_id, :name => 'jcam_judgment_commission_advice_id'
    add_index :judgment_commission_advice_members, :individual_id, :name => 'jcam_individual_id'

    add_foreign_key :judgment_commission_advice_members, :judgment_commission_advices, :name => 'jcam_judgment_commission_advice_fk'
    add_foreign_key :judgment_commission_advice_members, :individuals, :name => 'jcam_individual_fk'
  end
end
