require 'model_helper'
require 'app/models/record_price_item'
require 'app/models/record_price_budget_structure'

describe RecordPriceItem do
  it { should belong_to :record_price }
  it { should belong_to :administrative_process_budget_allocation_item }

  it { should have_many(:record_price_budget_structures).dependent(:destroy) }

  it { should validate_presence_of :record_price }
  it { should validate_presence_of :administrative_process_budget_allocation_item }

  context "with material" do
    let :administrative_process_budget_allocation_item do
      double :to_s => 'Cadeira'
    end

    it 'should administrative_process_budget_allocation_item response as to_s' do
      subject.stub(:administrative_process_budget_allocation_item).and_return(administrative_process_budget_allocation_item)

      expect(subject.to_s).to eq 'Cadeira'
    end
  end
end
