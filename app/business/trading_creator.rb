class TradingCreator
  def initialize(purchase_process, options = {})
    @purchase_process   = purchase_process
    @trading_repository = options.fetch(:trading_repository) { PurchaseProcessTrading }
    @trading_item_repository = options.fetch(:trading_item_repository) { PurchaseProcessTradingItem }
  end

  def self.create!(*params)
    new(*params).create
  end

  def create
    return unless allow_create_trading?

    if trading = trading_repository.create!(purchase_process_id: purchase_process.id)
      create_items(trading)
    end

    trading
  end

  private

  attr_reader :purchase_process, :trading_repository, :trading_item_repository

  def purchase_process_items
    purchase_process.items.reload
  end

  def allow_create_trading?
    purchase_process.present? && purchase_process.allow_trading_auto_creation?
  end

  def create_items(trading)
    if purchase_process.judgment_form_item?
      create_items_by_item(trading)
    elsif purchase_process.judgment_form_lot?
      create_items_by_lot(trading)
    end
  end

  def create_items_by_item(trading)
    purchase_process_items.each do |item|
      trading_item_repository.create!(trading_id: trading.id, item_id: item.id)
    end
  end

  def create_items_by_lot(trading)
    purchase_process_items.lots.each do |lot|
      trading_item_repository.create!(trading_id: trading.id, lot: lot)
    end
  end
end
