module CrudHelper
  def plural
    resource_class.model_name.human(:count => 'many')
  end

  def singular
    resource_class.model_name.human
  end

  def paginate
    will_paginate collection if collection.respond_to?(:total_pages)
  end

  # Get modal attributes and intersect with +params[:attributes]+ if exists
  def attributes
    if resource.decorator?
      attributes = resource.decorator.modal_attributes
    else
      attributes = resource_class.modal_attributes
    end
    attributes &= params[:attributes].split(',') if params[:attributes]

    associations = resource_class.reflect_on_all_associations

    attributes.map do |attribute|
      association = associations.detect{|association| association.foreign_key == attribute}

      # If attribute is an association and is not polymorphic, use the association
      # name instead of the foreign key.
      if association
        association.name unless association.options.include? :polymorphic
      else
        attribute
      end
    end.compact
  end

  def formatted_attribute(record, attribute)
    att = record.send attribute

    if att.kind_of?(TrueClass) || att.kind_of?(FalseClass)
      I18n.t(att)
    elsif record.respond_to?("#{attribute}_humanize")
      record.send "#{attribute}_humanize"
    else
      att
    end
  end

  def link_to_modal_info(id, href="#")
    link_to I18n.translate("other.tributario.messages.more_information"), href, :id => id.concat('_info_link'), :class => 'modal_info'
  end

  def create?
    can?(:create, controller_name) && respond_to?("new_#{controller_name.singularize}_path")
  end

  def create_link
    link_to t("#{controller_name}.new", :resource => singular, :cascade => true), new_resource_path
  end

  def filter?
    respond_to?("filter_#{controller_name}_path")
  end

  def filter_link
    link_to t("#{controller_name}.filter", :resource => plural, :cascade => true), filter_resources_path(current_scopes), :class => 'filter'
  end
end
