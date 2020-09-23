module ApplicationHelper
  include MenuHelper
  include MenuAuctionHelper
  include PeopleHelper

  def simple_form_for(object, *args, &block)
    options = args.extract_options!
    options[:builder] ||= Compras::FormBuilder
    options[:html] = { :class => dom_class(object) }

    super(object, *(args << options), &block)
  end

  def menu_link_to(location)
    link_to(t("controllers.#{location}"), send("#{location}_path"))
  end

  def find_input_for(value, setting, options = {})
    Compras::Inputs::FindInput.new(value, setting, options).find
  end

  def simple_menu(&block)
    SimpleMenu.new(self, &block).render
  end

  def smart_report_path(report)
    action = report.render_list? ? :new : :show

    url_for :controller => controller_name, :action => action, :id => "report", :only_path => true
  end

  def custom_fields(form)
    inputs = ""

    options = {}
    options[:lookup_chain] = form.object_name
    options[:nested_index] = form.options[:index]
    options[:template] = form.template

    form.object.class.reload_custom_data

    form.object.class.custom_data.each do |custom_data|
      inputs += form.input custom_data.normalized_data, find_input_for(form.object.send(custom_data.normalized_data), custom_data, options)
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
    content_tag(:script, :id => name, :type => "text/x-mustache") do
      content = capture(&block)
      content = content.gsub("</script>", "<\\/script>")
      content.html_safe
    end
  end

  def prefecture_image
    if current_prefecture && current_prefecture.image?
      image_tag current_prefecture.image.url
    else
      image_tag "prefecture.jpg"
    end
  end

  def back_link
    link_to "voltar", :back
  end

  def print_link
    link_to "imprimir", "javascript:window.print()"
  end

  def print_link_btn
    link_to "Imprimir", "javascript:window.print()", :class => "btn btn-primary"
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
    grouped_by = options.fetch(:grouped_by) { 4 }

    signed_object.signatures.in_groups_of(grouped_by, false)
  end

  def data_disabled_attribute(data_disabled = nil)
    return unless data_disabled

    " data-disabled=\"#{data_disabled}\"".html_safe
  end

  def full_path(relative_path, options = {})
    domain = options.fetch(:domain) { current_customer.domain }
    sub_path = options.fetch(:sub_path, "compras")
    protocol = options.fetch(:protocol, "https")

    "#{protocol}://#{domain}/#{sub_path}#{relative_path}"
  end

  def controller_asset?(options = {})
    options.merge!(:type => :js) unless options[:type]

    Rails.application.assets.find_asset "#{controller_name}.#{options[:type].to_s}"
  end

  def menu_sha1_digest
    Digest::SHA1.hexdigest(File.open("#{Rails.root}/config/locales/controllers.yml").read +
                           File.open("#{Rails.root}/config/menu.yml").read)
  end

  def menu_key
    ["compras-menu-#{current_customer.cache_key}",
     "profile-id-#{current_user.profile_id}",
     "profile-updated-at-#{current_user.profile_updated_at}",
     "controllers-sha1-digest-#{menu_sha1_digest}"].join("-")
  end

  def current_subpath
    Rails.env.development? ? ENV["RAILS_RELATIVE_URL_ROOT"].to_s : nil
  end

  def relative_link_to(body, url, html_options = {})
    link_to body, current_subpath.to_s + url, html_options
  end

  def date_mask(d)
    return d.strftime("%d/%m/%Y") unless d.nil?
  end
end
