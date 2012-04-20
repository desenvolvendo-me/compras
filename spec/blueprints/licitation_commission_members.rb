LicitationCommissionMember.blueprint(:membro) do
  individual { Individual.make!(:sobrinho) }
  role { LicitationCommissionMemberRole::ALTERNATE }
  role_nature { LicitationCommissionMemberRoleNature::EFECTIVE_SERVER }
  registration { "345678" }
end

LicitationCommissionMember.blueprint(:membro_presidente) do
  individual { Individual.make!(:wenderson) }
  role { LicitationCommissionMemberRole::PRESIDENT }
  role_nature { LicitationCommissionMemberRoleNature::EFECTIVE_SERVER }
  registration { "38" }
end
