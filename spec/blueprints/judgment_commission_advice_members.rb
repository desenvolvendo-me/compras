JudgmentCommissionAdviceMember.blueprint(:membro) do
  individual { Individual.make!(:wenderson) }
  role { LicitationCommissionMemberRole::PRESIDENT }
  role_nature { LicitationCommissionMemberRoleNature::EFECTIVE_SERVER }
  registration { "38" }
end
