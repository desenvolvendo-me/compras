require 'model_helper'
require 'app/models/persona/identity'
require 'app/models/identity'

describe Identity do
  it 'return number when converted to string' do
    subject.number = 'MG16236013'
    expect(subject.number).to eq subject.to_s
  end

  it { should belong_to :individual }
  it { should belong_to :state }

  it { should validate_presence_of :number }
  it { should validate_presence_of :issuer }
  it { should validate_presence_of :state }
  it { should validate_presence_of :issue }

  it { should_not allow_value(Date.current).for(:issue) }
  it { should allow_value(Date.yesterday).for(:issue) }
end
