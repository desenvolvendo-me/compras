require 'model_helper'
require 'app/models/reserve_allocation_type'

describe ReserveAllocationType do
  it 'should return to_s as description' do
    subject.description = 'Reserva'
    subject.to_s.should eq 'Reserva'
  end

  it { should validate_presence_of :description }
  it { should validate_presence_of :status }

  it { should have_many(:reserve_funds).dependent(:restrict) }
end
