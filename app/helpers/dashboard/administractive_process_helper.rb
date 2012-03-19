module Dashboard::AdministractiveProcessHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.administrative_processes
      m.judgment_forms
      m.licitation_processes
    end
  end
end
