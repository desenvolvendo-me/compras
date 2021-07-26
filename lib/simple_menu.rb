class SimpleMenu
  def initialize(template, &block)
    self.template = template
    self.block = block
    self.links = []
  end

  def render
    block.call(self)

    template.content_tag(:ul) do
      links.map(&:render).join.html_safe
    end
  end

  def method_missing(method, *arguments, &block)
    links << SimpleMenu::Item.new(template, method, *arguments, &block)
  end

  protected

  attr_accessor :template, :block, :links
end
