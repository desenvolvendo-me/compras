class LicitationCommissionMemberRoleNature < EnumerateIt::Base
  associate_values :public_agent, :commission_role, :efective_server, :temporary_server, :others
end
