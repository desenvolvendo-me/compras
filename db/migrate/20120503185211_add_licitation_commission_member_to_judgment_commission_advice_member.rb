class AddLicitationCommissionMemberToJudgmentCommissionAdviceMember < ActiveRecord::Migration
  def change
    add_column :judgment_commission_advice_members, :licitation_commission_member_id, :integer

    add_index :judgment_commission_advice_members, :licitation_commission_member_id, :name => 'jcam_licitation_commission_member_id'
    add_foreign_key :judgment_commission_advice_members, :licitation_commission_members, :name => 'jcam_licitation_commission_member_fk'
  end
end
