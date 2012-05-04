# encoding: utf-8
require 'model_helper'
require 'app/models/pledge_liquidation_cancellation'

describe PledgeLiquidationCancellation do
  it 'should return id as to_s' do
    subject.id = 1
    subject.to_s.should eq '1'
  end

  it { should belong_to :pledge }
  it { should belong_to :pledge_parcel }
  it { should belong_to :entity }

  it { should validate_presence_of :entity }
  it { should validate_presence_of :year }

  it { should_not allow_value('2a12').for(:year) }
  it { should allow_value('2012').for(:year) }

  context 'validate value' do
    it 'should not be valid if value greater than liquidations_value' do
      pledge_parcel = double(:value => 3, :liquidations_value => 3, :emission_date => nil)
      subject.stub(:pledge_parcel).and_return(pledge_parcel)
      subject.should_not allow_value(4).for(:value).with_message('não pode ser superior a soma das liquidações da parcela')
    end

    it 'should be valid if value is not greater than liquidations_value' do
      pledge_parcel = double(:value => 3, :liquidations_value => 2, :emission_date => nil)
      subject.stub(:pledge_parcel).and_return(pledge_parcel)
      subject.should allow_value(1).for(:value)
    end
  end

  context 'validate date' do
    before(:each) do
      described_class.stub(:last).and_return(double(:date => Date.new(2012, 3, 1)))
      described_class.stub(:any?).and_return(true)
    end

    it 'should be valid when date is equal to last' do
      subject.should allow_value('2012-03-1').for(:date)
    end

    it 'should not be valid when date is older to last' do
      subject.should_not allow_value('2011-01-01').for(:date).with_message('não pode ser menor que a data da última anulação de liquidação (01/03/2012)')
    end

    it 'should not be valid when date is older then emission_date' do
      subject.stub(:emission_date).and_return(Date.new(2012, 3, 29))
      subject.should_not allow_value(Date.new(2012, 3, 1)).for(:date).with_message('deve ser maior que a data de emissão')
    end
  end
end
