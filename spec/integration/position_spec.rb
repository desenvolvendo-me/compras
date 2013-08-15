require 'spec_helper'

describe Position do
  context 'uniqueness validations' do

    it { should validate_uniqueness_of(:name) }
  end
end
