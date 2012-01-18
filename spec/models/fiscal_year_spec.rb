require 'model_helper'
require 'app/models/fiscal_year'

describe FiscalYear do
  it { should validate_presence_of :year }

  it 'cast to string using year' do
    subject.year = 2011
    subject.to_s.should eq '2011'
  end
end
