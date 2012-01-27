require 'model_helper'
require 'app/models/communication_source'

describe CommunicationSource do
  it 'should return to_s as name' do
    subject.name = 'Jornal'
    subject.to_s.should eq 'Jornal'
  end

  it { should validate_presence_of :name }
end
