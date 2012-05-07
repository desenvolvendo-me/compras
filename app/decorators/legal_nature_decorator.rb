class LegalNatureDecorator < Decorator
  attr_modal :code, :name

  def summary
    component.code
  end
end
