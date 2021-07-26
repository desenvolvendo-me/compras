require 'spec_helper'

describe Partner do
  context 'uniqueness validations' do
    before { Partner.make!(:wenderson) }

    it { should validate_uniqueness_of(:person_id).scoped_to(:company_id) }
  end
end
