class CreateRealigmentPrice
  attr_accessor :proposal

  def initialize(proposal, proposal_repository = PurchaseProcessCreditorProposal)
    @proposal = proposal
    @proposal_repository = proposal_repository
  end

  def self.create!(*params)
    new(*params).create_realigment_price!
  end

  def create_realigment_price!
    if realignment_prices.empty?
      items.each do |item|
        realignment_prices.build(purchase_process_item: item, price: 0.00, brand: "", quantity: 0, delivery_date: "")
      end
    end
  end

  private

  def realignment_prices
    proposal.realigment_prices
  end

  def items
    proposal.licitation_process.items
  end
end
