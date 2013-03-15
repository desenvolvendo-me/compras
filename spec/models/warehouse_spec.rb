# encoding: utf-8
require 'model_helper'
require 'app/models/warehouse'
require 'app/models/materials_control'

describe Warehouse do
  it { should have_many(:materials_controls).dependent(:destroy) }

  describe '#to_s' do
    it 'should return the name' do
      subject.name = 'test'

      expect(subject.to_s).to eq 'test'
    end
  end
end
