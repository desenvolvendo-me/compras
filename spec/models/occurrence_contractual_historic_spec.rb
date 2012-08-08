# encoding: utf-8
require 'model_helper'
require 'app/models/occurrence_contractual_historic'

describe OccurrenceContractualHistoric do
  it { should belong_to :contract }

  it { should auto_increment(:sequence).by(:contract_id) }

  it { should validate_presence_of :occurrence_date }
  it { should validate_presence_of :observations }
  it { should validate_presence_of :occurrence_contractual_historic_type }
  it { should validate_presence_of :occurrence_contractual_historic_change }

  it 'should return sequence as to_s method' do
    subject.sequence = 1
    expect(subject.to_s).to eq '1'
  end
end
