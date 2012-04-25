class JudgmentCommissionAdviceMemberPresenter < Presenter::Proxy
  def individual_id_or_mustache_variable
    object.individual_id || "{{individual_id}}"
  end

  def role_or_mustache_variable
    object.role || "{{role}}"
  end

  def role_nature_or_mustache_variable
    object.role_nature || "{{role_nature}}"
  end

  def registration_or_mustache_variable
    object.registration || "{{registration}}"
  end

  def individual_name_or_mustache_variable
    unless object.individual_to_s.empty?
      object.individual_to_s
    else
      "{{individual_name}}"
    end
  end

  def cpf_or_mustache_variable
    object.individual_cpf || "{{cpf}}"
  end

  def role_humanize_or_mustache_variable
    object.role_humanize || "{{role_humanize}}"
  end

  def role_nature_humanize_or_mustache_variable
    object.role_nature_humanize || "{{role_nature_humanize}}"
  end
end
