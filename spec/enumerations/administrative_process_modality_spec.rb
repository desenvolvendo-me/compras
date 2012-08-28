# encoding: utf-8
require 'enumeration_helper'
require 'app/enumerations/administrative_process_modality'

describe AdministrativeProcessModality do
  context 'available for licitation process classification' do
    it 'should be available for licitation process classification' do
      expect(described_class.available_for_licitation_process_classification?('competition_for_purchases_and_services')).to be true
    end

    it 'should not be available for licitation process classification' do
      expect(described_class.available_for_licitation_process_classification?('auction')).to be false
    end
  end
end
