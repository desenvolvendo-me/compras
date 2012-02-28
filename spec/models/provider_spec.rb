# encoding: utf-8
require 'model_helper'
require 'app/models/provider'

describe Provider do
  it { should belong_to :person }

  it { should validate_presence_of :person }

  it 'should return person as to_s method' do
    subject.id = 1

    subject.to_s.should eq '1'
  end
end
