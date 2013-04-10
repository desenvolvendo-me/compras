# encoding: utf-8
class PurchaseProcessAccreditationCreditorDecorator
  include Decore
  include Decore::Proxy

  def creditor_representative
    super || 'Não possui representante'
  end
end
