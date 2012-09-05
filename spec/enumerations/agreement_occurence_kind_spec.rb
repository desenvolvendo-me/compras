# encoding: utf-8
require 'enumeration_helper'
require 'app/enumerations/agreement_occurrence_kind'

describe AgreementOccurrenceKind do
  it 'should return inactive kinds' do
    expect(described_class.liberation_availables).to eq [['Devolvido', 'returned'],
                                                         ['Rescindido', 'terminated'],
                                                         ['Outro', 'other'],
                                                         ['Paralisado', 'paralyzed'],
                                                         ['Finalizado', 'completed']]
  end
end
