class CreditorBalance < Compras::Model
  attr_accessible :fiscal_year, :current_assets, :long_term_assets,
                  :current_liabilities, :net_equity, :long_term_liabilities,
                  :liquidity_ratio_general, :current_radio,
                  :net_working_capital, :creditor_id, :fiscal_year

  belongs_to :creditor

  validates :fiscal_year, :mask => '9999', :allow_blank => true
  validates :fiscal_year, :creditor, :presence => true
end
