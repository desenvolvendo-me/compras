class TradingCreator
  def initialize(purchase_process, trading_repository = Trading)
    @purchase_process   = purchase_process
    @trading_repository = trading_repository
  end

  def self.create!(*params)
    new(*params).create
  end

  def create
    return unless allow_create_trading?

    @trading_repository.create(
      year: Date.current.year,
      licitation_process_id: @purchase_process.id)
  end

  private

  def allow_create_trading?
    @purchase_process.present? && @purchase_process.allow_trading_auto_creation?
  end
end
