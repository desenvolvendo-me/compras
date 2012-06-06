class IndexerDecorator < Decorator
  attr_modal :name

  def summary
    currency
  end
end
