require 'model_helper'
require 'app/models/fiscal_year'

describe FiscalYear do
  it { should validate_presence_of :year }

  it 'cast to string using year' do
    subject.year = 2011
    expect(subject.to_s).to eq '2011'
  end
end
