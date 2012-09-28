require 'model_helper'
require 'lib/signable'
require 'app/models/supply_authorization'

describe SupplyAuthorization do
  it 'should return to_s as code/year' do
    subject.code = '1'
    subject.year = 2012
    expect(subject.to_s).to eq '1/2012'
  end

  it { should belong_to :direct_purchase }

  it { should validate_presence_of :year }
  it { should validate_presence_of :direct_purchase }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('212').for(:year) }
  it { should_not allow_value('2a12').for(:year) }

  it { should auto_increment(:code).by(:year) }

  it { should have_db_index([:code, :year]).unique(true) }

  context '#annulled?' do
    before do
      subject.stub(:direct_purchase).and_return(direct_purchase)
    end

    let :direct_purchase do
      double(:direct_purchase)
    end

    it 'should be annulled when direct_purchase is annulled' do
      direct_purchase.stub(:annulled?).and_return(true)

      expect(subject.annulled?).to be true
    end

    it 'should not be annulled when direct_purchase is not annulled' do
      direct_purchase.stub(:annulled?).and_return(false)

      expect(subject.annulled?).to be false
    end
  end
end
