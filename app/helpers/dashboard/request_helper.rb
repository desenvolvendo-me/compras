module Dashboard::RequestHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.purchase_solicitations
    end
  end
end
