# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process_lot'
require 'app/models/licitation_process_bidder'
require 'app/models/licitation_process_bidder_proposal'
require 'app/models/administrative_process_budget_allocation_item'

describe LicitationProcessLot do
  it { should belong_to :licitation_process }
  it { should have_many(:administrative_process_budget_allocation_items).dependent(:nullify).order(:id) }

  it "should return 'Lote x' as to_s method" do
    subject.stub(:count_lots).and_return(1)
    subject.to_s.should eq "Lote 1"
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

  it 'should return the winner proposal by lot total value' do
    classificator = double(:winner_proposals => 'the winner proposals')
    classificator_class = double(:new => classificator)

    subject.winner_proposals(classificator_class).should eq 'the winner proposals'
  end
end
