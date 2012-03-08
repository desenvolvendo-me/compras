# encoding: utf-8
require 'model_helper'
require 'app/models/bid_opening'
require 'app/models/budget_allocation'
require 'app/models/organogram'
require 'app/models/employee'

describe BidOpening do
  it 'should return process/year as to_s' do
    subject.process = '1'
    subject.year = '2012'
    subject.to_s.should eq '1/2012'
  end

  it { should belong_to :organogram }
  it { should belong_to :budget_allocation }
  it { should belong_to :responsible }
  it { should belong_to :judgment_form }

  it { should validate_presence_of :year }
  it { should validate_presence_of :date }
  it { should validate_presence_of :organogram }
  it { should validate_presence_of :value_estimated }
  it { should validate_presence_of :budget_allocation }
  it { should validate_presence_of :modality }
  it { should validate_presence_of :object_type }
  it { should validate_presence_of :description }
  it { should validate_presence_of :judgment_form }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('212').for(:year) }
  it { should_not allow_value('2a12').for(:year) }

  it { should have_db_index([:process, :year]).unique(true) }
end
