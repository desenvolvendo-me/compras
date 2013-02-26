require 'model_helper'
require 'app/models/inscriptio_cursualis/state'
require 'app/models/state'
require 'app/models/customization_data'
require 'app/models/customization'
require 'app/business/options_parser'

describe CustomizationData do
  it { belong_to :customization }

  describe "validations" do
    before do
      subject.data_type = DataType::SELECT
    end

    it { should validate_presence_of :options }
  end

  describe '#normalized_data' do
    it 'should return normalized data' do
      subject.data = 'Nome de Um Campo'

      expect(subject.normalized_data).to eq 'nome_de_um_campo'
    end
  end

  describe "#options=" do
    it 'receives a string and splits it into an array' do
      OptionsParser.any_instance.should_receive(:parse).and_return(["option"])

      subject.options = "option"

      expect(subject.options).to eq ["option"]
    end
  end
end
