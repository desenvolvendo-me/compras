# encoding: utf-8
require 'enumeration_helper'
require 'app/enumerations/administrative_process_modality'

describe AdministrativeProcessModality do
  context 'available for licitation process classification' do
    it 'should return true' do
      expect(described_class.available_for_licitation_process_classification?('competition_for_purchases_and_services')).to be true
    end

    it 'should return false' do
      expect(described_class.available_for_licitation_process_classification?('auction')).to be false
    end
  end
end
