# encoding: utf-8
require 'enumeration_helper'
require 'app/enumerations/modality'
require 'app/enumerations/administrative_process_object_type'

describe Modality do
  describe '.available_for_object_type' do
    context 'when object_type is purchase_and_services' do
      let(:object_type) { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }

      it 'should return only concurrence, taken_price, invitation and trading' do
        expect(described_class.available_for_object_type(object_type)).to eq [
          Modality::CONCURRENCE, Modality::TAKEN_PRICE, Modality::INVITATION,
          Modality::TRADING]
      end
    end

    context 'when object_type is construction_and_engineering_services' do
      let(:object_type) { AdministrativeProcessObjectType::CONSTRUCTION_AND_ENGINEERING_SERVICES }

      it 'should return only concurrence, taken_price, invitation, comptetition and trading' do
        expect(described_class.available_for_object_type(object_type)).to eq [
          Modality::CONCURRENCE, Modality::TAKEN_PRICE, Modality::INVITATION,
          Modality::COMPETITION, Modality::TRADING]
      end
    end

    context 'when object_type is disposals_of_assets' do
      let(:object_type) { AdministrativeProcessObjectType::DISPOSALS_OF_ASSETS }

      it 'should return only auction' do
        expect(described_class.available_for_object_type(object_type)).to eq [Modality::AUCTION]
      end
    end

    context 'when object_type is concessions_and_permits' do
      let(:object_type) { AdministrativeProcessObjectType::CONCESSIONS_AND_PERMITS }

      it 'should return only concurrence' do
        expect(described_class.available_for_object_type(object_type)).to eq [Modality::CONCURRENCE]
      end
    end

    context 'when object_type is call_notice' do
      let(:object_type) { AdministrativeProcessObjectType::CALL_NOTICE }

      it 'should return only competition' do
        expect(described_class.available_for_object_type(object_type)).to eq [Modality::COMPETITION]
      end
    end

    context 'when object_type unknown' do
      let(:object_type) { 'whatever' }

      it 'should return an empty array' do
        expect(described_class.available_for_object_type(object_type)).to eq []
      end
    end
  end

  describe '.by_object_type' do
    it 'should return a array with the object_type as key and translation/value of modality' do
      expect(described_class.by_object_type).to eq({
        "call_notice" => [["Concurso", "competition"]],
        "concessions_and_permits" => [["Concorrência", "concurrence"]],
        "construction_and_engineering_services" => [["Concorrência", "concurrence"], ["Tomada de Preço", "taken_price"], ["Convite", "invitation"], ["Concurso", "competition"], ["Pregão", "trading"]],
        "disposals_of_assets" => [["Leilão", "auction"]],
        "purchase_and_services" => [["Concorrência", "concurrence"], ["Tomada de Preço", "taken_price"], ["Convite", "invitation"], ["Pregão", "trading"]]
      })
    end
  end
end
