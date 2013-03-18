# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_process_pulication_decorator'

  describe 'attr_header' do
    it 'should have header' do
      expect(described_class.headers?).to be_true
    end

    it 'should have name' do
      expect(described_class.header_attributes).to include :name
    end

     it 'should have publication_date' do
      expect(described_class.header_attributes).to include :publication_date
    end

     it 'should have publication_of' do
      expect(described_class.header_attributes).to include :publication_of
    end

     it 'should have circulation_type' do
      expect(described_class.header_attributes).to include :circulation_type
    end
end