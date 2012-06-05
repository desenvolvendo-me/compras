require 'model_helper'
require 'app/models/indexer_value'

describe IndexerValue do
  it { should belong_to :indexer }

  it { should validate_presence_of :date }
  it { should validate_presence_of :value }

  it 'fetch the current value from current indexer value' do
    described_class.stub(:current).and_return(double(:value => 3.00))
    described_class.current_value.should eq 3.00
  end
end
