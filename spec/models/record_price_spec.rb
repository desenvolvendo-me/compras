require 'model_helper'
require 'app/models/record_price'
require 'app/models/record_price_item'

describe RecordPrice do
  it { should belong_to :delivery_location }
  it { should belong_to :licitation_process }
  it { should belong_to :management_unit }
  it { should belong_to :payment_method }
  it { should belong_to :responsible }

  it { should have_many(:items).dependent(:destroy) }

  it { should validate_presence_of :licitation_process }
  it { should validate_presence_of :year }

  it 'should id as to_s' do
    subject.number = 1
    subject.year = 2012

    expect(subject.to_s).to eq '1/2012'
  end

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('212').for(:year) }
  it { should_not allow_value('2a12').for(:year) }

  it { should auto_increment(:number).by(:year) }
end
