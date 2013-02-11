# encoding: utf-8
require 'spec_helper'

describe ResourceAnnulsHelper do
  describe '#edit_title' do
    let(:resource) { double(:resource, :to_s => '1/2013') }

    it 'should return the title for edit' do
      helper.stub(:resource => resource)
      helper.should_receive(:parent_model_name_translation).and_return('Compra Direta')

      expect(helper.edit_title).to eq 'Anulação da Compra Direta 1/2013'
    end
  end

  describe '#new_title' do
    let(:resource) { double(:resource, :to_s => '1/2013') }

    it 'should return the title for new' do
      helper.stub(:resource => resource)
      helper.should_receive(:parent_model_name_translation).and_return('Compra Direta')

      expect(helper.new_title).to eq 'Anular Compra Direta 1/2013'
    end
  end
end
