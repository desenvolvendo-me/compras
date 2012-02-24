# encoding: utf-8
require 'model_helper'
require 'app/models/subfunction'
require 'app/models/budget_allocation'

describe Subfunction do
  it "should return code and description as to_s method" do
    subject.code = '01'
    subject.description = 'Subfunção'

    subject.to_s.should eq '01 - Subfunção'
  end

  it { should belong_to :function }
  it { should belong_to :entity }

  it { should validate_presence_of :code }
  it { should validate_numericality_of :code }
  it { should validate_presence_of :year }
  it { should validate_presence_of :entity }
  it { should validate_presence_of :description }
  it { should validate_presence_of :function_id }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('212').for(:year) }
  it { should_not allow_value('2a12').for(:year) }

  it { should have_many(:budget_allocations).dependent(:restrict) }
end
