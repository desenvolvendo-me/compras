require 'model_helper'
require 'app/models/purchase_process_trading'
require 'app/models/purchase_process_trading_bid'

describe PurchaseProcessTrading do
  it { should belong_to :purchase_process }

  it { should have_many(:bids).dependent(:restrict) }
  it { should have_many(:items).through(:purchase_process) }
  it { should have_many(:purchase_process_accreditation_creditors).through(:purchase_process_accreditation) }
  it { should have_many(:creditors).through(:purchase_process_accreditation_creditors) }

  it { should have_one(:judgment_form).through(:purchase_process) }
  it { should have_one(:purchase_process_accreditation).through(:purchase_process) }

  describe 'validations' do
    it { should validate_presence_of :purchase_process }
  end

  describe 'delegates' do
    it { should delegate(:kind).to(:judgment_form).allowing_nil(true) }
    it { should delegate(:kind_humanize).to(:judgment_form).allowing_nil(true) }
  end
end
