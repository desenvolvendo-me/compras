require 'model_helper'
require 'app/models/supply_authorization'
require 'app/models/signature_configuration'

describe SupplyAuthorization do
  it 'should return to_s as code/year' do
    subject.code = '1'
    subject.year = 2012
    subject.to_s.should eq '1/2012'
  end

  it { should belong_to :direct_purchase }

  it { should validate_presence_of :year }
  it { should validate_presence_of :direct_purchase }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('212').for(:year) }
  it { should_not allow_value('2a12').for(:year) }

  it { should have_db_index([:code, :year]).unique(true) }

  it 'should return signatures' do
    SignatureConfiguration.should_receive(:signatures_by_report).with('supply_authorizations').and_return([])
    subject.signatures.should eq []
  end
end
