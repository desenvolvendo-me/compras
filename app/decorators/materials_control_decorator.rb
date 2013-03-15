class MaterialsControlDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def minimum_quantity
    number_with_precision super if super
  end

  def maximum_quantity
    number_with_precision super if super
  end

  def average_quantity
    number_with_precision super if super
  end

  def replacement_quantity
    number_with_precision super if super
  end
end
