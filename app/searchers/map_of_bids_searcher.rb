class MapOfBidsSearcher
  include Quaestio
  repository PurchaseProcessTrading

  def licitation_process(id)
    where { purchase_process_id.eq id }
  end
end
