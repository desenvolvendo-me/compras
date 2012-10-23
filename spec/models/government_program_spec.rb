# encoding: utf-8
require 'model_helper'
require 'app/models/government_program'
require 'app/models/budget_allocation'

describe GovernmentProgram do
  it 'should return description' do
    subject.description = 'Habitação'
    expect(subject.to_s).to eq 'Habitação'
  end

  it { should belong_to :descriptor }

  it { should have_many(:budget_allocations).dependent(:restrict) }
end
