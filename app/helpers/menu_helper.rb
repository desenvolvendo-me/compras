module MenuHelper
  # Load the menu from a defined YAML file
  def render_menu(options = {})
    filename = options[:path] || Rails.root.join('config/menu.yml')

    menu = YAML::load_file(filename)['menu']

    content_tag :ul, load_menu(menu)
  end

  protected

  def load_menu(menu, html = "")
    return "" unless menu

    if menu.is_a?(Hash)
      menu.each do |name,item|
        unless item.is_a?(Hash) || item.is_a?(Array)
          html.concat render_link(name, item)
        else
          html.concat render_menu_item(name, item)
        end
      end
    elsif menu.is_a?(Array)
      menu.each do |item|
        html.concat content_tag(:li, load_menu(item))
      end
    else
      html.concat render_link(menu)
    end

    html.html_safe
  end

  def render_menu_item(name, item)
    name = localize_menu(name)

    html =  link_to(name, '#')
    html.concat content_tag(:ul, load_menu(item))
  end

  def localize_menu(name)
    I18n.t "menu.#{name}"
  end

  def resolve_url(name)
    send("#{name}_path")
  end

  def render_link(name, url = nil)
    url = url || resolve_url(name)
    name = localize_menu(name)

    link_to(name, url)
  end
end
