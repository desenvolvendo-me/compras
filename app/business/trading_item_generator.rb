class TradingItemGenerator
  def initialize(trading, trading_item_repository = TradingItem)
    @trading = trading
    @trading_item_repository = trading_item_repository
  end

  def self.generate!(*params)
    new(*params).generate_items!
  end

  def generate_items!
    trading.licitation_process_items.each do |item|
      trading_item_repository.create!(
        :trading_id => trading.id,
        :administrative_process_budget_allocation_item_id => item.id)
    end
  end

  private

  attr_reader :trading, :trading_item_repository
end
