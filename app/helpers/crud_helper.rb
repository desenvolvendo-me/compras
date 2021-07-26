module CrudHelper
  def plural(class_name = resource_class)
    class_name.model_name.human(:count => 'many')
  end

  def singular(class_name = resource_class)
    class_name.model_name.human
  end

  def new_title
    I18n.t("#{controller_name}.new", :resource => singular, :cascade => true)
  end

  def edit_title
    I18n.t("#{controller_name}.edit", :resource => singular, :cascade => true)
  end

  def paginate value = collection, options ={}
    super value, options if value.respond_to?(:total_pages)
  end

  # Get modal attributes and intersect with +params[:attributes]+ if exists
  def attributes
    attributes = resource_class.modal_attributes

    attributes &= params[:attributes].split(',') if params[:attributes]

    associations = resource_class.reflect_on_all_associations

    attributes.map do |attribute|
      association = associations.detect{ |relationship| relationship.foreign_key == attribute }

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
      I18n.t(att.to_s)
    elsif record.respond_to?("#{attribute}_humanize")
      record.send "#{attribute}_humanize"
    elsif att.kind_of?(Date) || att.kind_of?(DateTime) || att.kind_of?(Time)
      I18n.l(att)
    else
      att
    end
  end

  def link_to_modal_info(options = {})
    options[:label] ||= I18n.translate("other.compras.messages.more_information")
    options[:data_disabled_message] ||= I18n.translate('errors.messages.cannot_open_link_without_an_object')

    content_tag(:p, :class => :modal_info) do
      link_to options[:label], modal_info_link(options[:href]),
           'data-disabled' => options[:data_disabled] ? options[:data_disabled_message] : nil,
           'data-disabled-message' => options[:data_disabled_message]
    end
  end

  def create?
    can?(:create, main_controller_name) && respond_to?("new_#{main_controller_name.singularize}_path")
  end

  def create_link(optional_params = {}, optional_class = 'button primary')
    return unless optional_class.is_a?(String)
    link_to 'Cadastrar',
            new_resource_path(optional_params||{}),
            class: optional_class,
            title: t("#{controller_name}.new", resource: singular, cascade: true)
  end

  def filter?
    respond_to?("filter_#{controller_name}_path")
  end

  def filter_link optional_class = 'button primary'
    return unless optional_class.is_a?(String)
    link_to 'Busca avançada',
            filter_resources_path(current_scopes),
            class: "#{optional_class} filter",
            title: t("#{controller_name}.filter", resource: plural, cascade: true)

  end

  def auction_filter?
    respond_to?("filter_auction_#{controller_name}_path")
  end

  def clear_filter_link
    link_to t("clear_filter"), collection_path(:clear_filters => true)
  end

  def annul_link(options = {})
    annul_controller_name = options[:annul_controller_name] || "#{controller_name.singularize}_annuls"

    return unless can? :modify, annul_controller_name.to_sym

    annulled_method = options[:annulled_method] || "annulled?"
    param_name = options[:param_name] || "annullable_id"
    annul_object = options[:annul_object] || "annul"
    button_class = options[:button_class] || "negative"
    object = options[:resource] || resource
    label_new_annul = options[:label_for_new] || 'Anular'
    label_edit_annul = options[:label_for_edit] || 'Anulação'

    if object.persisted? && !object.send(annulled_method) && can?(:modify, main_controller_name)
      link_to label_new_annul, { :controller => annul_controller_name, :action => :new, param_name => object },
                        :class => "button #{button_class}", 'data-disabled' => options[:data_disabled]
    elsif object.send(annulled_method) && can?(:show, main_controller_name)
      link_to label_edit_annul, { :controller => annul_controller_name, :action => :edit, :id => object.annul },
                        :class => "button #{button_class}", 'data-disabled' => options[:data_disabled]
    end
  end

  def index_list_partial
    if resource_class.respond_to?(:decorated?) && resource_class.decorated? && resource_class.decorator.respond_to?(:headers?) && resource_class.decorator.headers?
      'list_with_header'
    else
      'list'
    end
  end

  def grouped_fields_tag(title, &block)
    field_set_tag title, :class => 'group' do
      content_tag :div, :class => 'wrapper' do
        block.call
      end
    end
  end

  def modal_info_link(resource)
    resource ? send("modal_info_#{resource.class.to_s.underscore}_path", resource) : "#"
  end

  def state_format(state)
    StatePreposition.new(state).format
  end

  def not_updateable_message
    return unless resource.respond_to?(:updateable?)

    unless (resource.updateable? && resource.persisted?) || resource.new_record?
      I18n.t("activerecord.errors.messages.cant_be_updated")
    end
  end

  def not_destroyable_message
    return unless resource.respond_to?(:destroyable?)

    unless resource.destroyable?
      I18n.t("activerecord.errors.messages.cant_be_destroyed")
    end
  end

  def month_years
    date = []
    (I18n.t('date.month_names')[1..12] * 2).each_with_index do |month, index|
      index += 1
      year = index <= 12 ? Date.today.year : Date.today.year + 1
      date.push(["#{month}/#{year}","01/#{index > 12 ? "#{index - 12}".rjust(2,'0') : "#{index}".rjust(2,'0')}/#{year}"])
    end
    date
  end

  def date_mask(d)
    d.strftime("%d/%m/%Y") unless d.nil?
  end

  def time_mask(t)
    t.strftime("%H:%M h") unless t.nil?
  end
end
