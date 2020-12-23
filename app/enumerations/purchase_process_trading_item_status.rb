class PurchaseProcessTradingItemStatus < EnumerateIt::Base
  associate_values :closed, :failed, :opened, :pending

  def self.allowed_for_negotiation
    allowed = [CLOSED, FAILED]
    to_a.select { |i| allowed.include?(i[1]) }
  end
end
