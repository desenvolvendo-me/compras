class MapOfProposalSearcher
  include Quaestio
  repository PurchaseProcessCreditorProposal

  def licitation_process(id)
    joins { licitation_process }.where { licitation_process.id.eq id }
  end

  def order(order)
    query = scoped
    case order
    when MapProposalReportOrder::CREDITOR_NAME
      query = query.joins { creditor.person }.order( 'unico_people.name' )
    when MapProposalReportOrder::PRICE_ASC
      query.order { unit_price }
    when MapProposalReportOrder::PRICE_DESC
      query.order { 'unit_price DESC' }
    end
  end
end
