# encoding: utf-8
require 'spec_helper'

describe CrudHelper do
  describe '#new_title' do
    it 'should return the title for new' do
      helper.stub(:controller_name => 'tradings')
      helper.stub(:singular => 'Pregão')

      expect(helper.new_title).to eq 'Criar Pregão'
    end
  end

  describe '#edit_title' do
    it 'should return the title for edit' do
      helper.stub(:singular => 'Pregão')

      expect(helper.edit_title).to eq 'Editar Pregão'
    end
  end
end
