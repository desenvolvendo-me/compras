# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process_lot'
require 'app/models/administrative_process_budget_allocation_item'

describe LicitationProcessLot do
  it { should belong_to :licitation_process }
  it { should have_many(:administrative_process_budget_allocation_items).dependent(:nullify).order(:id) }

  it "should return the observations as to_s method" do
    subject.observations = "some observation"

    subject.to_s.should eq "some observation"
  end

  it "items from related administrative process should be valid" do
    item = double(:administrative_process_id => 1)

    subject.stub(:administrative_process_budget_allocation_items).and_return([item])
    subject.stub(:administrative_process_id).and_return(1)

    subject.valid?

    subject.errors.messages[:administrative_process_budget_allocation_items].should be_nil
  end

  it "items from another administrative process should not be valid" do
    item = double(:administrative_process_id => 1)

    subject.stub(:administrative_process_budget_allocation_items).and_return([item])
    subject.stub(:administrative_process_id).and_return(2)

    subject.valid?

    subject.errors.messages[:administrative_process_budget_allocation_items].should include "somente são permitidos itens do processo administrativo relacionado"
  end
end
