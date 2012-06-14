require 'unit_helper'
require 'app/business/reserve_fund_status_changer'

describe ReserveFundStatusChanger do
  subject do
    described_class.new(reserve_fund)
  end

  before do
    subject.stub(:annul_status).and_return('annul')
  end

  let :reserve_fund do
    double('ReserveFund')
  end

  it 'should annul' do
    reserve_fund.should_receive(:update_attribute).with(:status, 'annul')

    subject.change!
  end
end
