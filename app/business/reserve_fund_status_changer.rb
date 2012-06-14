class ReserveFundStatusChanger
  attr_accessor :reserve_fund

  def initialize(reserve_fund)
    self.reserve_fund = reserve_fund
  end

  def change!
    reserve_fund.update_attribute(:status, annul_status)
  end

  protected

  def annul_status
    ReserveFundStatus::ANNULLED
  end
end
