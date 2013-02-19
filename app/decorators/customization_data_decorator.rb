#encoding: utf-8
class CustomizationDataDecorator
  include Decore
  include Decore::Proxy

  def options
    return unless super

    super.map do |option|
      option.is_a?(Array) ? option.first : option
    end.join(', ')
  end
end
