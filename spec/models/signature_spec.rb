require 'model_helper'
require 'app/models/signature'

describe Signature do
  it 'should return people name as to_s' do
    subject.stub(:person).and_return(double('Person', :to_s => 'Nohup'))
    subject.to_s.should eq 'Nohup'
  end

  it { should belong_to :person }
  it { should belong_to :position }

  it { should validate_presence_of :person }
  it { should validate_presence_of :position }
end
