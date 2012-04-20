require 'unit_helper'
require 'app/business/administrative_process_items_cleaner'

describe AdministrativeProcessItemsCleaner do

  let(:administrative_process_storage) do
    double 'administrative process storage'
  end

  let(:administrative_process_budget_allocation) do
    double("administrative process budget allocation")
  end

  let(:administrative_process) do
    double('administrative process',
           :administrative_process_budget_allocations => [administrative_process_budget_allocation])
  end

  let(:subject) do
    AdministrativeProcessItemsCleaner.new(1, administrative_process_storage)
  end

  it 'should call clean_items on each administrative_process_budget_allocations' do
    administrative_process_storage.should_receive(:find).and_return(administrative_process)

    administrative_process_budget_allocation.should_receive(:clean_items!)

    subject.clean_items!.should be_true
  end
end
