require 'report_helper'
require 'enumerate_it'
require 'app/reports/minute_purchase_process_report'

describe MinutePurchaseProcessReport do
  let :minute_purchase_process_searcher_repository do
    double(:minute_purchase_process_searcher_repository)
  end

  subject do
    described_class.new minute_purchase_process_searcher_repository
  end
end
