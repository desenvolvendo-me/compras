module PeopleHelper
  def society_kind_name(form_builder, mustache)
    partial_society_kind_name(form_builder, mustache) + '[extended_partner_attributes][society_kind]'
  end

  def society_kind_id(form_builder, mustache)
    partial_society_kind_id(form_builder, mustache) + '_extended_partner_attributes_society_kind'
  end

  private

  def partial_society_kind_name(form_builder, mustache)
    name = object_name(form_builder)

    if mustache
      name += '[{{uuid_partner}}]'
    end

    name
  end

  def partial_society_kind_id(form_builder, mustache)
    new_id = sanitized_object_name(form_builder)

    if mustache
      new_id += '_{{uuid_partner}}'
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
    if params[:by_legal_people] === 'true'
      "Empresas"
    elsif params[:by_physical_people] === 'true'
      "Pessoas"
    end
  end

  def page_title_singular
    if params[:company] === 'true'
      "Empresa"
    elsif params[:people] === 'true'
      "Pessoa"
    end
  end

  def edit_link resource
    if params[:by_legal_people] === 'true'
      edit_resource_path(resource, company: true )
    elsif params[:by_physical_people] === 'true'
      edit_resource_path(resource, people: true )
    end
  end

  def people_type
    if params[:by_legal_people] === 'true'
      { company: true }
    elsif params[:by_physical_people] === 'true'
      { people: true }
    end
  end
end
