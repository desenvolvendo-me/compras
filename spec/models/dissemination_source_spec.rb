# encoding: utf-8
require 'model_helper'
require 'app/models/dissemination_source'

describe DisseminationSource do
  it 'should return to_s method with description' do
    subject.description = 'Jornal Oficial do Município'
    subject.to_s.should eq 'Jornal Oficial do Município'
  end

  it { should belong_to :communication_source }

  it { should validate_presence_of :description }
  it { should validate_presence_of :communication_source }
end
