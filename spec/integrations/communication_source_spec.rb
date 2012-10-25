# encoding: UTF-8
require 'spec_helper'

describe CommunicationSource do
  context 'uniqueness validations' do
    before { CommunicationSource.make!(:jornal_municipal) }

    it { should validate_uniqueness_of(:description) }
  end
end