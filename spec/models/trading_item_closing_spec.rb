require 'model_helper'
require 'app/models/trading_item_closing'

describe TradingItemClosing do
  it { should belong_to :trading_item }

  it { should validate_presence_of :trading_item }
  it { should validate_presence_of :status }
end
