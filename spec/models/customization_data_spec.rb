require 'model_helper'
require 'app/models/customization_data'
require 'app/models/customization'

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
      subject.options = "foo, bar,baz "
      expect(subject.options).to eq %w(foo bar baz)
    end
  end
end
