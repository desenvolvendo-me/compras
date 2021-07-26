class PurchaseProcessCreditorDisqualificationDecorator
  include Decore
  include Decore::Proxy

  def lot_kind_radio_collection
    [['Lotes da proposta', PurchaseProcessCreditorDisqualificationKind::PARTIAL],
     ['Toda proposta', PurchaseProcessCreditorDisqualificationKind::TOTAL]]
  end
end
