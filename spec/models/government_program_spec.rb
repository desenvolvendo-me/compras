# encoding: utf-8
require 'model_helper'
require 'app/models/government_program'
require 'app/models/budget_allocation'

describe GovernmentProgram do
  it 'should return description' do
    subject.description = 'Habitação'
    subject.to_s.should eq 'Habitação'
  end

  it { should belong_to :entity }
  it { should belong_to :descriptor }

  it { should have_many(:budget_allocations).dependent(:restrict) }

  it { should validate_presence_of :descriptor }
  it { should validate_presence_of :entity }
  it { should validate_presence_of :year }
  it { should validate_presence_of :description }
  it { should validate_presence_of :status }

  it { should allow_value('1999').for(:year) }
  it { should_not allow_value('201a').for(:year) }
end
