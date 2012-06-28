class IndexerValueDecorator < Decorator
  def value
    helpers.number_with_precision(original_component.value, :precision => scale_of_value)
  end
end
