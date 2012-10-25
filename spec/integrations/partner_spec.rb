# encoding: UTF-8
require 'spec_helper'

describe Partner do
  context 'uniqueness validations' do
    before { Partner.make!(:sobrinho) }

    it { should validate_uniqueness_of(:person_id).scoped_to(:company_id) }
  end
end