class SubfunctionDecorator < Decorator
  def summary
    component.function.to_s
  end
end
