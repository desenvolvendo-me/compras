# encoding: UTF-8
require 'spec_helper'

describe LegalTextNature do
  context 'uniqueness validations' do
    before { LegalTextNature.make!(:civica) }

    it { should validate_uniqueness_of(:description) }
  end
end