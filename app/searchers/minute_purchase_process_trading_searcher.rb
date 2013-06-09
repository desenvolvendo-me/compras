class MinutePurchaseProcessTradingSearcher
  include Quaestio
  repository LicitationProcess

  def licitation_process(id)
    where { self.id.eq id }
  end
end
