module BookmarksHelper
  def content_classes
    "dashboard #{super}"
  end

  def bookmarks
    simple_menu do |m|
      resource.links.each do |link|
        m.send link.controller_name
      end
    end
  end

  def links
    Link.ordered.select do |link|
      can? :read, link.controller_name
    end
  end
end
