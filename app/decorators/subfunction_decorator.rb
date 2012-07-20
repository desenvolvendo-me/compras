class SubfunctionDecorator
  include Decore
  include Decore::Proxy

  def summary
    component.function.to_s
  end
end
