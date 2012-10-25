# encoding: UTF-8
require 'spec_helper'

describe ApplicationCode do
  context 'uniqueness validations' do
    before { ApplicationCode.make!(:geral) }

    it { should validate_uniqueness_of(:code).scoped_to(:variable).with_message(:taken_for_variable) }
  end
end