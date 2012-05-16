# encoding: utf-8
module ApplicationHelper
  def simple_form_for(object, *args, &block)
    options = args.extract_options!
    options[:builder] ||= Tributario::FormBuilder
    options[:html] = { :class => dom_class(resource) }

    super(object, *(args << options), &block)
  end

  def simple_menu(&block)
    SimpleMenu.new(self, &block).render
  end

  def area_field(value)
    "#{number_with_precision(value)} m2"
  end

  def smart_report_url
    url_for :controller => controller_name, :action => :show, :id => 'report'
  end

  # Apply I18n::Alchemy on a collection of active record objects.
  #
  # Usage:
  #
  #   localized(products) do |product|
  #     product.price #=> "1,50"
  #   end
  #
  #   products = localized(products)
  #   products.first.price #=> "1,50"
  def localized(collection_object)
    if block_given?
      collection_object.each { |object| yield(object.localized) }
    else
      collection_object.map { |object| object.localized }
    end
  end

  def options_for_input(object_setting)
    options = {}
    if object_setting
      options.merge!(:label => "#{object_setting.name} (Unidade de referência: #{ object_setting.reference_unit})")
      options.merge!(:collection => object_setting.options.map(&:name)) if object_setting.collection?
      options.merge!(:as => :boolean) if object_setting.boolean?
      options.merge!(:as => :date) if object_setting.date?
      options.merge!(:as => :datetime) if object_setting.datetime?
      options[:input_html] ||= {}
      options[:input_html]['data-attribute-name'] = object_setting.name.parameterize.to_s
      if object_setting.respond_to?(:dependency) && object_setting.dependency.present?
        options[:input_html]['data-dependency'] = object_setting.dependency.name.parameterize.to_s
        options[:input_html][:disabled] = :disabled
      end
    end
    options
  end

  def find_input_for(value, setting)
    Tributario::FindInput.new(value, setting).find
  end

  def value_by_field_type(value, setting)
    return if value.blank?

    case setting.field_type
    when 'boolean'
      t (value == '1').to_s
    when 'date' || 'datetime'
      l value.send("to_#{setting.field_type}")
    when 'collection'
      setting.property_variable_setting_options.find(value).name
    else
      value
    end
  end

  def mustache(name, &block)
    content_tag(:script, :id => name, :type => 'text/x-mustache') do
      content = capture(&block)
      content = content.gsub("</script>", "<\\/script>")
      content.html_safe
    end
  end

  def prefecture_image
    if current_prefecture && current_prefecture.image?
      image_tag current_prefecture.image.url
    else
      image_tag 'prefecture.jpg'
    end
  end

  def builder(resource, json)
    json.id resource.id
    json.value resource.to_s
    yield
  end
end
