require 'report_helper'
require 'enumerate_it'
require 'app/enumerations/purchase_process_object_type'
require 'app/enumerations/modality'
require 'app/reports/bidding_schedule_report'

describe BiddingScheduleReport do
  let :bidding_schedule_searcher_repository do
    double(:bidding_schedule_searcher_repository)
  end

  subject do
    described_class.new bidding_schedule_searcher_repository
  end

  it{ should validate_presence_of :start_date }
  it{ should validate_presence_of :end_date }
end
