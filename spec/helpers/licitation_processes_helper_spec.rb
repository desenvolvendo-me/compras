# encoding: utf-8
require 'spec_helper'

describe LicitationProcessesHelper do
  describe '#edit_title' do
    let(:resource) { double(:resource, :administrative_process => '1/2013', :to_s => '3/2013') }

    it 'should return the title for edit' do
      helper.stub(:resource => resource)

      expect(helper.edit_title).to eq 'Editar Processo Licitatório 3/2013 do Processo Administrativo 1/2013'
    end
  end
end
