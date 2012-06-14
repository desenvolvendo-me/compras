require 'model_helper'
require 'app/models/direct_purchase'
require 'app/models/employee'
require 'app/models/direct_purchase_liberation'

describe DirectPurchaseLiberation do
  it { should belong_to :direct_purchase }
  it { should belong_to :employee }

  it { should validate_presence_of :direct_purchase }
  it { should validate_presence_of :employee }
  it { should validate_presence_of :evaluation }

  describe '#to_s' do
    it 'should be equals to the liberation id' do
      subject.stub(:id).and_return 1

      subject.to_s.should eq "1"
    end
  end
end
