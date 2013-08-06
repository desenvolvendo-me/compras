module PledgeRequestsHelper
  def reserve_funds(purchase_process)
    return [] unless purchase_process

    purchase_process.reserve_funds_available.map do |reserve_fund|
      [
        reserve_fund.id,
        reserve_fund.to_s,
        { 'data-amount' => number_with_precision(reserve_fund.amount) }
      ]
    end
  end
end
