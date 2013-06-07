require 'report_helper'
require 'enumerate_it'
require 'app/enumerations/id_name_order_type'
require 'app/reports/minute_purchase_process_trading_report'

describe MinutePurchaseProcessTradingReport do
  let :minute_purchase_process_trading_searcher_repository do
    double(:minute_purchase_process_trading_searcher_repository)
  end

  subject do
    described_class.new minute_purchase_process_trading_searcher_repository
  end

  it 'has order by name as default' do
    expect(subject.order_type).to eq IdNameOrderType::NAME
  end

  it 'list all' do
    minute_purchase_process_trading_searcher_repository.should_receive(:search).with(:order => IdNameOrderType::NAME)

    subject.records
  end

  it 'list all ordered by id' do
    subject.order_type = IdNameOrderType::ID

    minute_purchase_process_trading_searcher_repository.should_receive(:search).with(:order => IdNameOrderType::ID)

    subject.records
  end
end
