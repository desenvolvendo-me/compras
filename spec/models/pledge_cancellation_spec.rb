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
  it { should validate_presence_of :kind }
  it { should validate_presence_of :reason }

  it { should belong_to :pledge }
  it { should belong_to :pledge_expiration }

  it 'should not be valid if all other cancellations for pledge_expiration is greater than canceled_value' do
    pledge_expiration = double(:pledge_cancellations => [double(:value => 1), double(:value => 1)], :value => 3)
    subject.stub(:pledge_expiration).and_return(pledge_expiration)
    subject.should_not allow_value(4).for(:value_canceled).with_message("não pode ser maior que a soma do que já foi anulado ou o valor do vencimento")
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
      subject.should_not allow_value('2011-01-01').for(:date).with_message("não pode ser menor que a data da última anulação (01/03/2012)")
    end
  end
end
