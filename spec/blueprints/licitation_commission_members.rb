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

LicitationCommissionMember.blueprint(:membro_pregoeiro) do
  individual { Individual.make!(:joao_da_silva) }
  role { LicitationCommissionMemberRole::AUCTIONEER }
  role_nature { LicitationCommissionMemberRoleNature::EFECTIVE_SERVER }
  registration { "38" }
end

LicitationCommissionMember.blueprint(:membro_equipe_apoio) do
  individual { Individual.make!(:pedro_dos_santos) }
  role { LicitationCommissionMemberRole::SUPPORT_TEAM }
  role_nature { LicitationCommissionMemberRoleNature::EFECTIVE_SERVER }
  registration { "38" }
end
