# encoding: UTF-8
require 'spec_helper'

describe LicitationModality do
  context 'uniqueness validations' do
    before { LicitationModality.make!(:publica) }

    it { should validate_uniqueness_of(:initial_value).scoped_to(:final_value).with_message(:initial_and_final_value_range_taken) }
  end
end