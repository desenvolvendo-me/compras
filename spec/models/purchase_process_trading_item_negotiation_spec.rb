require 'model_helper'
require 'app/models/purchase_process_trading_item_negotiation'

describe PurchaseProcessTradingItemNegotiation do
  it { should belong_to :item }
  it { should belong_to :accreditation_creditor }

  it { should validate_presence_of :item }
  it { should validate_presence_of :purchase_process_accreditation_creditor_id }
  it { should validate_presence_of :amount }
end
