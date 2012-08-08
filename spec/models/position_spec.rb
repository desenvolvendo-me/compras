require 'model_helper'
require 'app/models/position'
require 'app/models/employee'

describe Position do
  it 'should return name as to_s' do
    subject.name = 'Gerente'
    expect(subject.to_s).to eq 'Gerente'
  end

  it { should validate_presence_of :name }

  it { should have_many(:employees).dependent(:restrict) }
end
