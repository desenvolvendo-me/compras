module PeopleHelper
  def society_kind_name(form_builder, mustache)
    partial_society_kind_name(form_builder, mustache) + "[extended_partner_attributes][society_kind]"
  end

  def society_kind_id(form_builder, mustache)
    partial_society_kind_id(form_builder, mustache) + "_extended_partner_attributes_society_kind"
  end

  private

  def partial_society_kind_name(form_builder, mustache)
    name = object_name(form_builder)

    if mustache
      name += "[{{uuid_partner}}]"
    end

    name
  end

  def partial_society_kind_id(form_builder, mustache)
    new_id = sanitized_object_name(form_builder)

    if mustache
      new_id += "_{{uuid_partner}}"
    end

    new_id
  end

  def sanitized_object_name(form_builder)
    form_builder.sanitized_object_name
  end

  def object_name(form_builder)
    form_builder.object_name
  end

  def page_title_plural
    if company?
      "Fornecedores"
    elsif individual?
      "Pessoas"
    end
  end

  def page_title_singular
    if company?
      "Fornecedor"
    elsif individual?
      "Pessoa"
    end
  end

  def create_link(optional_params = {})
    new_path = new_legal_people_path(optional_params || {}) if company?
    new_path = new_physical_people_path(optional_params || {}) if individual?
    link_to "Cadastrar",
            new_path,
            class: "button primary",
            title: t("#{controller_name}.new", resource: singular, cascade: true)
  end

  def edit_link(resource)
    if company?
      edit_resource_path(resource, company: true)
    elsif individual?
      edit_resource_path(resource, people: true)
    end
  end

  def people_type
    if company?
      { company: true }
    elsif individual?
      { people: true }
    end
  end

  def filter_link
    current_scopes[:personable_type] = PersonableType::COMPANY if company?
    current_scopes[:personable_type] = PersonableType::INDIVIDUAL if individual?
    link_to "Busca avançada",
            filter_resources_path(current_scopes),
            class: "button primary filter",
            title: t("#{controller_name}.filter", resource: plural, cascade: true)
  end

  def company?
    true if @person_type == PersonableType::COMPANY
  end

  def individual?
    true if @person_type == PersonableType::INDIVIDUAL
  end
end
