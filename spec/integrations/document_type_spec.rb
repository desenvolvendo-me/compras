# encoding: UTF-8
require 'spec_helper'

describe DocumentType do
  context 'uniqueness validations' do
    before { DocumentType.make!(:fiscal) }

    it { should validate_uniqueness_of(:description) }
  end
end