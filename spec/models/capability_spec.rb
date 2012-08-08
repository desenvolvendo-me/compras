# encoding: utf-8
require 'model_helper'
require 'app/models/capability'
require 'app/models/budget_allocation'
require 'app/models/licitation_process'
require 'app/models/extra_credit_moviment_type'
require 'app/models/budget_revenue'

describe Capability do
  it 'should return to_s as description' do
    subject.description = 'Reforma e Ampliação'
    expect(subject.to_s).to eq 'Reforma e Ampliação'
  end

  it { should belong_to :descriptor }

  it { should have_many(:budget_allocations).dependent(:restrict) }
  it { should have_many(:licitation_processes).dependent(:restrict) }
  it { should have_many(:extra_credit_moviment_types).dependent(:restrict) }
  it { should have_many(:budget_revenues).dependent(:restrict) }

  it { should validate_presence_of :descriptor }
  it { should validate_presence_of :status }
  it { should validate_presence_of :description }
  it { should validate_presence_of :goal }
  it { should validate_presence_of :kind }
end
