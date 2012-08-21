class PurchaseSolicitationItemGroupDecorator
  include Decore
  include Decore::Proxy

  def allow_submit_button?
    !component.annulled? && component.editable?
  end
end
