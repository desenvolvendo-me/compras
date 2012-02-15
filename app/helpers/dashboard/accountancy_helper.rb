module Dashboard::AccountancyHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.organogram_configurations
      m.organograms
    end
  end
end
