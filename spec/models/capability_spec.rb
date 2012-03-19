# encoding: utf-8
require 'model_helper'
require 'app/models/capability'
require 'app/models/budget_allocation'

describe Capability do
  it 'should return to_s as description' do
    subject.description = 'Reforma e Ampliação'
    subject.to_s.should eq 'Reforma e Ampliação'
  end

  it { should belong_to :entity }
  it { should have_many(:budget_allocations).dependent(:restrict) }
  it { should have_many(:licitation_processes).dependent(:restrict) }

  it { should validate_presence_of :status }
  it { should allow_value('1999').for(:year) }
  it { should_not allow_value('201a').for(:year) }
end
