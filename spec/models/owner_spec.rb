# encoding: utf-8
require 'model_helper'
require 'app/models/owner'

describe Owner do
  it 'should return person as to_s' do
    subject.stub(:person).and_return('José')
    subject.to_s.should eq 'José'
  end

  it { should belong_to :person }
  it { should belong_to :property }
end
