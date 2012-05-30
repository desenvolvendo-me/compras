require 'model_helper'
require 'app/models/supply_authorization'

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

  context 'signatures' do
    let :signature_configuration_item do
      double('SignatureConfigurationItem')
    end

    let :signature_configuration_item_store do
      double('SignatureConfigurationItemStore')
    end

    it 'should return related signatures' do
      signature_configuration_item_store.should_receive(:all_by_configuration_report).with('supply_authorization').and_return [signature_configuration_item]
      subject.signatures(signature_configuration_item_store).should eq [signature_configuration_item]
    end
  end
end
