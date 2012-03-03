# encoding: utf-8
require 'model_helper'
require 'app/models/reserve_allocation_type'

describe ReserveAllocationType do
  it 'should return to_s as description' do
    subject.description = 'Reserva'
    subject.to_s.should eq 'Reserva'
  end

  it "should return true for is_licitation? method when description is Licitação" do
    subject.description = "Licitação"

    subject.should be_licitation
  end

  it "should return false for is_licitation? method when description is not Licitação" do
    subject.description = "Comum"

    subject.should_not be_licitation
  end

  it { should validate_presence_of :description }
  it { should validate_presence_of :status }

  it { should have_many(:reserve_funds).dependent(:restrict) }
end
