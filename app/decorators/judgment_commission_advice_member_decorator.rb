class JudgmentCommissionAdviceMemberDecorator
  include Decore
  include Decore::Proxy

  def licitation_commission_member_id_or_mustache_variable
    component.licitation_commission_member_id || "{{licitation_commission_member_id}}"
  end

  def registration_or_mustache_variable
    component.licitation_commission_member_registration || "{{registration}}"
  end

  def individual_name_or_mustache_variable
    unless component.licitation_commission_member_to_s.empty?
      component.licitation_commission_member_to_s
    else
      "{{individual_name}}"
    end
  end

  def cpf_or_mustache_variable
    component.licitation_commission_member_individual_cpf || "{{cpf}}"
  end

  def role_humanize_or_mustache_variable
    component.licitation_commission_member_role_humanize || "{{role_humanize}}"
  end

  def role_nature_humanize_or_mustache_variable
    component.licitation_commission_member_role_nature_humanize || "{{role_nature_humanize}}"
  end
end
