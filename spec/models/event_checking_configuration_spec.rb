require 'model_helper'
require 'app/models/event_checking_configuration'

describe EventCheckingConfiguration do
  it { should belong_to :descriptor }

  it { should validate_presence_of :event }
  it { should validate_presence_of :function }
  it { should validate_presence_of :descriptor }

  it 'should return event as to_s' do
    subject.event = 'Evento Tal'
    expect(subject.to_s).to eq 'Evento Tal'
  end
end
