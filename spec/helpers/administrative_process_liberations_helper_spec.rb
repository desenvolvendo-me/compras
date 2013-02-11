# encoding: utf-8
require 'spec_helper'

describe AdministrativeProcessLiberationsHelper do
  describe '#edit_title' do
    let(:resource) { double(:resource, :administrative_process => '1/2013') }

    it 'should return the title for edit' do
      helper.stub(:resource => resource)

      expect(helper.edit_title).to eq 'Liberação do Processo Administrativo 1/2013'
    end
  end
end
