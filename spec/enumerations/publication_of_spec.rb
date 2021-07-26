require 'enumeration_helper'
require 'app/enumerations/publication_of'

describe PublicationOf do
  describe '.allowed_for_direct_purchase' do
    it 'should exclude edital' do
      expect(described_class.allowed_for_direct_purchase).to eq [
        ["Cancelamento", "canceling"],
        ["Homologação", "ratification"],
        ["Outros", "others"],
        ["Prorrogação", "extension"],
        ["Ratificação", "confirmation"],
        ["Retificação do edital", "edital_rectification"],
        ["Vencedores", "winners"]
      ]
    end
  end
end
