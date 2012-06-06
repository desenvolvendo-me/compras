class CreditorBalance < ActiveRecord::Base
  attr_accessible :fiscal_year, :current_assets, :long_term_assets
  attr_accessible :current_liabilities, :net_equity, :long_term_liabilities
  attr_accessible :liquidity_ratio_general, :current_radio, :net_working_capital
  attr_accessible :creditor_id, :fiscal_year

  belongs_to :creditor

  validates :fiscal_year, :mask => '9999', :allow_blank => true
  validates :fiscal_year, :presence => true
end
