class SignatureDecorator < Decorator
  def summary
    position.to_s
  end
end
