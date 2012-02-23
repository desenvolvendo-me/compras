# encoding: utf-8
require 'model_helper'
require 'app/models/commitment_type'

describe CommitmentType do
  it 'should return code and description as to_s' do
    subject.code = 998
    subject.description = 'Empenho 01'
    subject.to_s.should eq '998 - Empenho 01'
  end

  it { should validate_presence_of :code }
  it { should validate_presence_of :description }

  it { should allow_value('012').for(:code) }
  it { should_not allow_value('12').for(:code) }
  it { should_not allow_value('2012').for(:code) }

  it { should have_many(:pledges).dependent(:restrict) }
end
