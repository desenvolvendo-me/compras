require 'model_helper'
require 'app/models/communication_source'

describe CommunicationSource do
  it 'should return to_s as description' do
    subject.description = 'Jornal'
    subject.to_s.should eq 'Jornal'
  end

  it { should validate_presence_of :description }
end
