# encoding: utf-8
require 'enumeration_helper'
require 'app/enumerations/agreement_occurrence_kind'

describe AgreementOccurrenceKind do
  it 'should return inactive kinds' do
    expect(described_class.inactive_kinds).to eq [['Devolvido', 'returned'],
                                                  ['Finalizado', 'completed'],
                                                  ['Outro', 'other'],
                                                  ['Paralisado', 'paralyzed'],
                                                  ['Rescindido', 'terminated']]
  end
end
