module Dashboard::AdministractiveProcessHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.bid_openings
      m.judgment_forms
      m.licitation_processes
    end
  end
end
