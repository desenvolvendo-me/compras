require 'model_helper'
require 'app/models/regulatory_act_type'
require 'app/models/regulatory_act'

describe RegulatoryActType do
  it 'should return description as to_s method' do
    subject.description = 'Lei'
    expect(subject.to_s).to eq 'Lei'
  end

  it { should have_many(:regulatory_acts).dependent(:restrict) }

  it { should validate_presence_of :description }

  context 'default values' do
    it { expect(subject.imported).to be false }
  end

  context '#updateable?' do
    it 'returns true if not imported' do
      subject.imported = false
      expect(subject.updateable?).to eq true
    end

    it 'returns false if imported' do
      subject.imported = true
      expect(subject.updateable?).to eq false
    end
  end

  context '#destroyable?' do
    it 'returns true if not imported' do
      subject.imported = false
      expect(subject.destroyable?).to eq true
    end

    it 'returns false if imported' do
      subject.imported = true
      expect(subject.destroyable?).to eq false
    end
  end
end
