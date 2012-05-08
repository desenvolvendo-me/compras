# encoding: utf-8
require 'model_helper'
require 'app/models/subpledge_cancellation'

describe SubpledgeCancellation do
  it 'should return id as to_s' do
    subject.id = 1
    subject.to_s.should eq '1'
  end

  it { should validate_presence_of :entity }
  it { should validate_presence_of :year }
  it { should validate_presence_of :pledge }
  it { should validate_presence_of :subpledge }
  it { should validate_presence_of :subpledge_expiration }
  it { should validate_presence_of :value }
  it { should validate_presence_of :date }
  it { should validate_presence_of :reason }

  it { should belong_to :entity }
  it { should belong_to :pledge }
  it { should belong_to :subpledge }
  it { should belong_to :subpledge_expiration }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201a').for(:year) }

  context 'validate pledge' do
    it 'should not accept pledge without subpledges' do
      pledge = double('Pledge', :has_subpledges? => false)
      subject.stub(:pledge).and_return(pledge)

      subject.valid?

      subject.errors.messages[:pledge].should include 'deve ter subempenhos'
    end

    it 'should accept pledge with subpledges' do
      pledge = double('Pledge', :has_subpledges? => true)
      subject.stub(:pledge).and_return(pledge)

      subject.valid?

      subject.errors.messages[:pledge].should be_nil
    end
  end

  context 'validate value' do
    before do
      subject.stub(:subpledge_expiration).and_return(subpledge_expiration)
    end

    let :subpledge_expiration do
      double('SubpledgeExpiration', :balance => 3)
    end

    it 'should not be valid if value greater than subpledge_expiratin_balance' do
      subject.should_not allow_value(4).for(:value).
                                        with_message('não pode ser superior ao saldo da parcela')
    end

    it 'should be valid if value is not greater than balance' do
      subject.should allow_value(1).for(:value)
    end
  end
end
