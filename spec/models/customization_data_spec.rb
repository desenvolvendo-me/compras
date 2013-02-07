require 'model_helper'
require 'app/models/customization_data'
require 'app/models/customization'

describe CustomizationData do
  it { belong_to :customization }

  describe '#normalized_data' do
    it 'should return normalized data' do
      subject.data = 'Nome de Um Campo'

      expect(subject.normalized_data).to eq 'nome_de_um_campo'
    end
  end
end
