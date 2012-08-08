require 'model_helper'
require 'app/models/indexer'
require 'app/models/indexer_value'
require 'app/models/licitation_process'

describe Indexer do
  it { should belong_to :currency }

  it { should have_many :indexer_values }
  it { should have_many :licitation_processes }

  it { should validate_presence_of :name }

  it 'cast to string using name' do
    subject.name = 'UFM'
    expect(subject.name).to eq 'UFM'
  end

  it 'fetch the current value from current indexer value' do
    subject.stub(:indexer_values).and_return(double(:current_value => 3.00))
    expect(subject.current_value).to eq 3.00
  end
end
