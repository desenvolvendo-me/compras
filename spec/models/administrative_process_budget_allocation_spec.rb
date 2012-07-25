# encoding: utf-8
require 'model_helper'
require 'app/models/administrative_process_budget_allocation'
require 'app/models/administrative_process_budget_allocation_item'
require 'app/models/material'

describe AdministrativeProcessBudgetAllocation do
  it { should belong_to :administrative_process }
  it { should belong_to :budget_allocation }
  it { should have_many(:items).dependent(:destroy).order(:id) }

  it { should validate_presence_of :budget_allocation }
  it { should validate_presence_of :value }
  it { should validate_duplication_of(:material_id).on(:items) }

  it 'should return the total value of the items' do
    item_one = double(:estimated_total_price => 100, :marked_for_destruction? => false)
    item_two = double(:estimated_total_price => 300, :marked_for_destruction? => false)

    # this should not be considered
    item_three = double(:estimated_total_price => 200, :marked_for_destruction? => true)

    subject.stub(:items).and_return([item_one, item_two, item_three])

    subject.total_items_value.should eq 400
  end

  it 'should call the destroy_all method on items when calling clean_items method' do
    items_collection = double('items')

    subject.stub(:items).and_return(items_collection)

    items_collection.should_receive(:destroy_all)

    subject.clean_items!
  end
end
