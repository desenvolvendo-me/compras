class CustomizationDataDecorator
  include Decore
  include Decore::Proxy

  def options
    super.join(', ') if super
  end
end
