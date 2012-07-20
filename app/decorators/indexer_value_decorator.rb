class IndexerValueDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def value
    number_with_precision(component.value, :precision => scale_of_value)
  end
end
