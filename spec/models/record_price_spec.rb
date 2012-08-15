require 'model_helper'
require 'app/models/record_price'

describe RecordPrice do
  it { should belong_to :delivery_location }
  it { should belong_to :licitation_process }
  it { should belong_to :management_unit }
  it { should belong_to :payment_method }
  it { should belong_to :responsible }

  it { should validate_presence_of :licitation_process }

  it 'should id as to_s' do
    subject.year = 2012
    subject.stub(:count_by_year_and_less_than_me).and_return(1)

    expect(subject.to_s).to eq '2012/1'
  end
end
