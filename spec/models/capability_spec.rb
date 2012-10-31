# encoding: utf-8
require 'model_helper'
require 'app/models/capability'

describe Capability do
  it 'should return to_s as description' do
    subject.description = 'Reforma e Ampliação'
    expect(subject.to_s).to eq 'Reforma e Ampliação'
  end

  it { should belong_to :descriptor }
end
