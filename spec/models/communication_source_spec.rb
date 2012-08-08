require 'model_helper'
require 'app/models/communication_source'
require 'app/models/dissemination_source'

describe CommunicationSource do
  it 'should return to_s as description' do
    subject.description = 'Jornal'
    expect(subject.to_s).to eq 'Jornal'
  end

  it { should have_many(:dissemination_sources).dependent(:restrict) }

  it { should validate_presence_of :description }
end
