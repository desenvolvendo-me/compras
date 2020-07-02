module ProfilesHelper
  def roles(object_roles, menu, title)
    group_menus(menu, title)

    roles = []

    @group.keys.each do |key|
      roles << object_roles.find {|r| r.controller == key }
    end

    roles.compact.sort_by(&:controller_name)
  end

  def group_menus(menus, title)
    @group = {}

    menus[title].each do |m|
      extract(m, title)
    end
  end

  def extract(item, title)
    if item.is_a?(Hash)
      extract(item.values.flatten, [title, item.keys.first])
    elsif item.is_a?(Array)
      item.each do |i|
        extract(i, title)
      end
    else
      @group[item] ||= []
      @group[item] << title
      @group[item].flatten!
    end
  end

  def full_path(controller)
    @group[controller].collect{|c| localize_menu(c)}.join(' > ') + ' > '
  end

  def grouped_fields_tag(title = "", id = nil, &block)
    field_set_tag title, class: 'group', id: id do
      content_tag :div, class: 'wrapper' do
        block.call
      end
    end
  end

  def permission_class(role)
    role.permission
  end
end
