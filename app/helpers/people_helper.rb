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
end
