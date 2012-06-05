class IndexerValueDecorator < Decorator
  def value
    helpers.number_with_precision super, :precision => 6
  end
end
