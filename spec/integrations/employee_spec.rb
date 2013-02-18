# encoding: UTF-8
require 'spec_helper'

describe Employee do
  context 'uniqueness validations' do
    before { Employee.make!(:sobrinho) }

    it { should validate_uniqueness_of(:individual_id) }
    it { should validate_uniqueness_of(:registration) }
  end
end
