# encoding: UTF-8
require 'spec_helper'

describe AdministrationType do
  context 'uniqueness validations' do
    before { AdministrationType.make!(:publica) }

    it { should validate_uniqueness_of(:description) }
  end
end