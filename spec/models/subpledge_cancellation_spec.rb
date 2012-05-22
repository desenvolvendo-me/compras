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
  it { should validate_presence_of :value }
  it { should validate_presence_of :date }
  it { should validate_presence_of :reason }

  it { should belong_to :entity }
  it { should belong_to :pledge }
  it { should belong_to :subpledge }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201a').for(:year) }

  context 'validate pledge' do
    it 'should not accept pledge without subpledges' do
      pledge = double('Pledge', :subpledges? => false)
      subject.stub(:pledge).and_return(pledge)

      subject.valid?

      subject.errors.messages[:pledge].should include 'deve ter subempenhos'
    end

    it 'should accept pledge with subpledges' do
      pledge = double('Pledge', :subpledges? => true)
      subject.stub(:pledge).and_return(pledge)

      subject.valid?

      subject.errors.messages[:pledge].should be_nil
    end
  end

  context 'validate value' do
    before do
      subject.stub(:subpledge).and_return(subpledge)
    end

    let :subpledge do
      double('Subpledge', :balance => 3)
    end

    it 'should not be valid if value greater than subpledge_expiratin_balance' do
      subject.should_not allow_value(4).for(:value).
                                        with_message('não pode ser superior ao saldo do subempenho')
    end

    it 'should be valid if value is not greater than balance' do
      subject.should allow_value(1).for(:value)
    end
  end

  context 'movimentable subpledge_expirations' do
    before do
      subject.stub(:subpledge).and_return(subpledge)
    end

    let :subpledge do
      double('Subpledge', :subpledge_expirations_with_balance => subpledge_expirations)
    end

    let :subpledge_expirations do
      [
        double('SubpledgeExpirationOne', :balance => 200),
        double('SubpledgeExpirationTwo', :balance => 500)
      ]
    end

    it 'should return subpledge expirations with balance' do
      subject.movimentable_subpledge_expirations.should eq subpledge_expirations
    end
  end
end
