LicitationCommissionMember.blueprint(:membro) do
  individual { Individual.make!(:sobrinho) }
  role { LicitationCommissionMemberRole::ALTERNATE }
  role_nature { LicitationCommissionMemberRoleNature::EFECTIVE_SERVER }
  registration { "345678" }
end
