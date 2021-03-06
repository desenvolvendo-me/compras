require 'model_helper'
require 'app/models/extended_company_size'

describe ExtendedCompanySize do
  it { should belong_to :company_size }

  it 'should have false as the default value for benefited' do
    expect(subject.benefited).to be_false
  end
end
