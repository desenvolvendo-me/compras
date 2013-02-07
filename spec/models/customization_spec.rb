require 'model_helper'
require 'app/enumerations/customization_model'
require 'app/models/customization'
require 'app/models/inscriptio_cursualis/state'
require 'app/models/state'

describe Customization do
  it { belong_to :state }

  it { have_many(:data).dependent(:destroy) }

  describe '#to_s' do
    it 'should return state - model as to_s' do
      subject.stub(:state => 'Minas Gerais')
      subject.model = CustomizationModel::CREDITOR

      expect(subject.to_s).to eq 'Minas Gerais - Credor'
    end
  end
end
