# encoding: UTF-8
require 'spec_helper'

describe Material do
  context 'uniqueness validations' do
    before { Material.make!(:antivirus) }

    it { should validate_uniqueness_of(:description) }
  end
end