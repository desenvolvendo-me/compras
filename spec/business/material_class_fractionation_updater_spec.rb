require 'unit_helper'
require 'app/business/material_class_fractionation_updater'

describe MaterialClassFractionationUpdater do
  let(:material) { double(:material) }
  let(:fractionation_creator) { double(:fractionation_creator) }

  describe  '#update' do
    subject do
      described_class.new(material, fractionation_creator: fractionation_creator)
    end

    it 'should recreate all fractionation with the material' do
      licitation1 = double(:licitation1)
      licitation2 = double(:licitation2)

      material.should_receive(:licitation_processes).and_return [licitation1, licitation2]

      fractionation_creator.should_receive(:create!).with(licitation1)
      fractionation_creator.should_receive(:create!).with(licitation2)

      subject.update
    end
  end

  describe '.update' do
    it 'should instantiate and call update' do
      instance = double(:instance)
      described_class.should_receive(:new).with(material).and_return instance

      instance.should_receive(:update)

      described_class.update(material)
    end
  end
end
