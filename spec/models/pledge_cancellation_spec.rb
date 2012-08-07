# encoding: utf-8
require 'model_helper'
require 'app/models/pledge_cancellation'

describe PledgeCancellation do
  it 'should return id as to_s' do
    subject.id = 1
    subject.to_s.should eq '1'
  end

  it { should validate_presence_of :pledge }
  it { should validate_presence_of :date }
  it { should validate_presence_of :reason }

  it { should validate_numericality_of :value }

  it { should allow_value(10).for(:value) }
  it { should_not allow_value(0).for(:value) }
  it { should_not allow_value(-1).for(:value) }

  it { should belong_to :pledge }

  context 'validate value' do
    before do
      subject.stub(:pledge).and_return(pledge)
    end

    let :pledge do
      double('Pledge', :emission_date => nil, :balance => 3.0)
    end

    it 'should not be valid if value greater than pledge balance' do
      subject.should_not allow_value(4).for(:value).with_message("não pode ser superior ao saldo do empenho (R$ 3,00)")
    end

    it 'should be valid if value is not greater than pledge balance' do
      subject.should allow_value(1).for(:value)
    end
  end

  context 'validate date' do
    before(:each) do
      described_class.stub(:last).and_return(double(:date => Date.new(2012, 3, 1)))
      described_class.stub(:any?).and_return(true)
    end

    it 'should be valid when date is equal to last' do
      subject.should allow_value(Date.new(2012, 3, 1)).for(:date)
    end

    it 'should not be valid when date is older to last' do
      subject.should_not allow_value(Date.new(2011, 1, 1)).for(:date).with_message("não pode ser menor que a data da última anulação (01/03/2012)")
    end

    it 'should not be valid when date is older then emission_date' do
      subject.stub(:emission_date).and_return(Date.new(2012, 3, 29))
      subject.should_not allow_value(Date.new(2012, 3, 1)).for(:date).with_message("deve ser igual ou maior que a data de emissão")
    end
  end
end
