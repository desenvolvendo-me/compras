module Dashboard::ManagementHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.users
      m.profiles
    end
  end
end
