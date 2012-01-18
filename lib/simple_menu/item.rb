class SimpleMenu::Item
  def initialize(template, controller)
    self.template = template
    self.controller = controller
  end

  def render
    return unless have_permission?

    template.content_tag(:li) do
      template.link_to(name, controller)
    end
  end

  protected

  attr_accessor :template, :controller

  def have_permission?
    template.can?(:read, controller)
  end

  def name
    template.translate(controller, :scope => :controllers)
  end
end
