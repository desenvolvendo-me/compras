require 'model_helper'
require 'app/models/indexer_value'

describe IndexerValue do
  it { should belong_to :indexer }

  it { should validate_presence_of :date }
  it { should validate_presence_of :value }
end
