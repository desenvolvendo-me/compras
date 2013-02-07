# encoding: utf-8
module ApplicationHelper
  include MenuHelper

  def simple_form_for(object, *args, &block)
    options = args.extract_options!
    options[:builder] ||= Compras::FormBuilder
    options[:html] = { :class => dom_class(resource) }

    super(object, *(args << options), &block)
  end

  def find_input_for(value, setting, options = {})
    Compras::Inputs::FindInput.new(value, setting, options).find
  end

  def simple_menu(&block)
    SimpleMenu.new(self, &block).render
  end

  def area_field(value)
    "#{number_with_precision(value)} m2"
  end

  def numeric_position(value)
    I18n.t "number.placing", :count => value
  end

  def smart_report_path
    url_for :controller => controller_name, :action => :show, :id => 'report', :only_path => true
  end

  def custom_fields(form)
    inputs = ''

    resource.class.custom_data.each do |custom_data|
      inputs += form.input custom_data.normalized_data, find_input_for( form.object.send(custom_data.normalized_data), custom_data )
    end

    inputs.html_safe
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

  def back_link
    link_to 'voltar', :back
  end

  def print_link
    link_to 'imprimir', 'javascript:window.print()'
  end

  def message_about_environment?
    Rails.env.test? || Rails.env.development? || Rails.env.staging? || Rails.env.training?
  end

  def builder(resource, json)
    json.id resource.id
    json.value resource.to_s
    yield
  end

  def signatures_grouped(options = {})
    signed_object = options.fetch(:signed_object) { resource }
    grouped_by    = options.fetch(:grouped_by) { 4 }

    signed_object.signatures.in_groups_of(grouped_by, false)
  end

  def data_disabled_attribute(data_disabled = nil)
    return unless data_disabled

    " data-disabled=\"#{ data_disabled }\"".html_safe
  end

  def full_path(relative_path, options = {})
    domain  = options.fetch(:domain) { current_customer.domain }
    sub_path = options.fetch(:sub_path, 'compras')
    protocol  = options.fetch(:protocol, 'https')

    "#{protocol}://#{domain}/#{sub_path}#{relative_path}"
  end
end
