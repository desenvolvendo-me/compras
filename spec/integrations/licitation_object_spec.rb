# encoding: UTF-8
require 'spec_helper'

describe LicitationObject do
  context 'uniqueness validations' do
    before { LicitationObject.make!(:ponte) }

    it { should validate_uniqueness_of(:description).scoped_to(:year).with_message(:taken_for_informed_year) }
  end
end