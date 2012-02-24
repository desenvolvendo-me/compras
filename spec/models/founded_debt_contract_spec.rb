require 'model_helper'
require 'app/models/founded_debt_contract'

describe FoundedDebtContract do
  it 'should return to_s as id/year' do
    subject.id = 1
    subject.year = 2012
    subject.to_s.should eq '1/2012'
  end

  it { should belong_to :entity }
  it { should validate_presence_of :year }
  it { should validate_presence_of :entity }
  it { should validate_presence_of :contract_number }
  it { should validate_presence_of :process_number }
  it { should validate_presence_of :signed_date }
  it { should validate_presence_of :end_date }
  it { should validate_presence_of :description }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('212').for(:year) }
  it { should_not allow_value('12').for(:year) }
  it { should_not allow_value('a12').for(:year) }
end
