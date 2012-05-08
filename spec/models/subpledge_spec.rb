# encoding: utf-8
require 'model_helper'
require 'app/models/subpledge'
require 'app/models/subpledge_expiration'
require 'app/models/subpledge_cancellation'

describe Subpledge do
  it 'should return id as to_s' do
    subject.id = 1
    subject.to_s.should eq '1'
  end

  it { should belong_to :entity }
  it { should belong_to :pledge }
  it { should belong_to :provider }

  it { should have_many(:subpledge_expirations).dependent(:destroy) }
  it { should have_many(:subpledge_cancellations).dependent(:restrict) }

  it { should validate_presence_of :entity }
  it { should validate_presence_of :year }
  it { should validate_presence_of :pledge }
  it { should validate_presence_of :provider }
  it { should validate_presence_of :date }
  it { should validate_presence_of :value }
  it { should validate_presence_of :process_number }
  it { should validate_presence_of :description }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201a').for(:year) }
  it { should_not allow_value('201').for(:year) }

  context 'balance' do
    let :subpledge_cancellations do
      [
        double('SubpledgeCancellationsOne', :value => 1),
        double('SubpledgeCancellationsOne', :value => 2),
      ]
    end

    it 'should return correct balance' do
      subject.value = 10
      subject.stub(:subpledge_cancellations).and_return(subpledge_cancellations)
      subject.balance.should eq 7
    end
  end

  context 'next_number' do
    it 'should return 1 as first subpledge' do
      pledge = double('Pledge', :last_subpledge => nil)
      subject.stub(:pledge).and_return(pledge)
      subject.next_number.should eq 1
    end

    it 'should return 2 as secondary subpledge' do
      pledge = double('Pledge', :last_subpledge => double('Subpledge', :number => 1))
      subject.stub(:pledge).and_return(pledge)
      subject.next_number.should eq 2
    end
  end

  context 'validate date' do
    before do
      described_class.stub(:last).and_return(double(:date => Date.new(2012, 3, 1)))
      described_class.stub(:any?).and_return(true)
    end

    it 'should be valid when date is equal to last' do
      subject.should allow_value('2012-03-1').for(:date)
    end

    it 'should not be valid when date is older to last' do
      subject.should_not allow_value('2011-01-01').for(:date).with_message('não pode ser menor que a data do último subempenho (01/03/2012)')
    end

    it 'should not be valid when date is older then emission_date' do
      subject.stub(:emission_date).and_return(Date.new(2012, 3, 29))
      subject.should_not allow_value(Date.new(2012, 3, 1)).for(:date).with_message('deve ser maior que a data de emissão do empenho')
    end
  end

  context 'validate value' do
    let :pledge do
      double('Pledge', {
        :balance => 3,
        :emission_date => nil,
        :global? => false,
        :estimated? => true,
        :pledge_parcels => []
      })
    end

    it 'should not be valid if value greater than balance' do
      subject.stub(:pledge).and_return(pledge)
      subject.should_not allow_value(4).for(:value).with_message("não pode ser superior ao saldo do empenho")
    end

    it 'should be valid if value is not greater than balance' do
      subject.stub(:pledge).and_return(pledge)
      subject.should allow_value(1).for(:value)
    end
  end

  context 'validate pledge' do
    it 'pledge_type is global' do
      pledge = double('Pledge', :emission_date => nil, :pledge_parcels => [], :global? => true, :estimated? => false)
      subject.stub(:pledge).and_return(pledge)
      subject.valid?
      subject.errors[:pledge].should_not include 'deve ser do tipo global ou estimativo'
    end

    it 'pledge_type is estimated' do
      pledge = double('Pledge', :emission_date => nil, :pledge_parcels => [], :global? => false, :estimated? => true)
      subject.stub(:pledge).and_return(pledge)
      subject.valid?
      subject.errors[:pledge].should_not include 'deve ser do tipo global ou estimativo'
    end

    it 'pledge_type is ordinary' do
      pledge = double('Pledge', :emission_date => nil, :pledge_parcels => [], :global? => false, :estimated? => false, :ordinary? => true)
      subject.stub(:pledge).and_return(pledge)
      subject.valid?
      subject.errors[:pledge].should include 'deve ser do tipo global ou estimativo'
    end
  end
end
