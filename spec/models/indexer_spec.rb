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
end
