require 'report_helper'
require 'enumerate_it'
require 'app/enumerations/map_proposal_report_order'
require 'app/reports/map_of_proposal_report'

describe MapOfProposalReport do
  let :licitation_process_repository do
    double(:licitation_process_repository)
  end

  subject do
    described_class.new licitation_process_repository
  end

  it { should validate_presence_of :order }
end
