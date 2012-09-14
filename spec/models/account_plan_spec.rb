require 'model_helper'
require 'app/models/account_plan'

describe AccountPlan do
  it 'should return title as to_s' do
    subject.title = 'Bancos conta corrente'
    expect(subject.to_s).to eq 'Bancos conta corrente'
  end

  it { should belong_to :account_plan_configuration }

  it { should validate_presence_of :title }
  it { should validate_presence_of :checking_account }
  it { should validate_presence_of :function }
  it { should validate_presence_of :account_plan_configuration }

  it { should validate_presence_of :nature_balance }
  it { should validate_presence_of :nature_information }
  it { should validate_presence_of :nature_balance_variation }
  it { should validate_presence_of :surplus_indicator }
  it { should validate_presence_of :movimentation_kind }

  it { expect(subject.bookkeeping).to be_false }

  context 'validate mask' do
    before do
      subject.stub(:mask).and_return('99/9')
    end

    it { should allow_value('12/3').for(:checking_account) }
    it { should_not allow_value('0a-0').for(:checking_account) }
  end
end
