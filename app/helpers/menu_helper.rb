module MenuHelper
  # TODO: use POROs to control the menu generator
  # Load the menu from a defined YAML file
  def render_menu(options = {})
    filename = options[:path] || 'config/menu.yml'

    menu = YAML::load_file(filename)['menu']

    load_menu(menu)
  end

  protected

  def load_menu(menu, html = "")
    return "" unless menu

    if menu.is_a?(Hash)
      menu.each do |name, item|
        html.concat render_menu_item(name, item)
      end
    elsif menu.is_a?(Array)
      menu.each do |item|
        html.concat render_link_or_item(item)
      end
    else
      html.concat render_link(menu)
    end

    html.html_safe
  end

  def render_menu_item(name, item)
    return "" unless can_show?(item)

    name = localize_menu(name)

    html =  link_to(name, '#')
    html.concat content_tag(:ul, load_menu(item))
  end

  def render_link_or_item(item)
    return "" unless can_show?(item)

    content_tag(:li, load_menu(item))
  end

  def render_link(name, url = nil)
    return "" unless can_show?(name)

    url = url || resolve_path(name)

    name = localize_menu(name)

    return name if url.blank?

    link_to(name, url)
  end

  def can_show?(node)
    if node.is_a?(Hash)
      node.map { |_, value| can_show?(value) }.include?(true)
    elsif node.is_a?(Array)
      node.map { |value| can_show?(value) }.include?(true)
    else
      can?(:read, MainControllerGetter.new(node).name)
    end
  end

  def localize_menu(name)
    translated_name = I18n.t "menu.#{name}"

    if translated_name.include?("translation missing")
      name
    else
      translated_name
    end
  end

  def resolve_path(name)
    path = "#{name}_path"

    send(path) if respond_to?(path)
  end
end
