# encoding: utf-8
require 'spec_helper'

describe LicitationProcessLotsHelper do
  describe '#edit_title' do
    let(:resource) { double(:resource, :licitation_process => '1/2013', :to_s => '2/2013') }

    it 'should return the title for edit' do
      helper.stub(:resource => resource)

      expect(helper.edit_title).to eq 'Editar 2/2013 do Processo Licitatório 1/2013'
    end
  end
end
