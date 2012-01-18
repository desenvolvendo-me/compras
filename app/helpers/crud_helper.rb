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
    attributes  = resource_class.modal_attributes
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

  def link_to_modal_info(id)
    link_to I18n.translate("other.tributario.messages.more_information"), "#", :id => id.concat('_info_link'), :class => 'modal_info'
  end

  def link_to_new
    link_to t("#{controller_name}.new", :resource => singular, :cascade => true), new_resource_path, :class => 'button primary new'
  end

  def link_to_filter
    link_to t("#{controller_name}.filter", :resource => plural, :cascade => true), filter_resources_path(current_scopes), :class => 'button secondary filter'
  end
end
