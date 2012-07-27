class IndexerValueDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def value
    number_with_precision(super, :precision => scale_of_value) if super
  end
end
