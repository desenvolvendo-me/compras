class BidderCreditorCreator
  def initialize(purchase_process,  purchase_process_repository = LicitationProcess)
    @purchase_process = purchase_process
    @purchase_process_repository = purchase_process_repository
  end

  def self.create!(*params)
    new(*params).create_bidders!
  end

  def create_bidders!
    return nil unless bidders.empty?
    items.each  do |item|
      bidders.create!(licitation_process_id: purchase_process.id, creditor_id: item.creditor.id)
    end
  end

  private
  attr_reader :purchase_process

  def items
    purchase_process.items
  end

  def bidders
    purchase_process.bidders
  end
end
