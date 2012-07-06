# encoding: utf-8
require 'model_helper'
require 'app/models/pledge_liquidation'
require 'app/models/pledge_parcel_movimentation'
require 'lib/annullable'
require 'app/models/resource_annul'

describe PledgeLiquidation do
  it 'should return id as to_s' do
    subject.id = 1
    subject.to_s.should eq '1'
  end

  it { should validate_presence_of :pledge }
  it { should validate_presence_of :value }
  it { should validate_presence_of :date }

  it { should validate_numericality_of :value }

  it { should belong_to :pledge }

  it { should have_many(:pledge_parcel_movimentations).dependent(:restrict) }

  it { should have_one(:annul).dependent(:destroy) }

  it { should allow_value(23).for(:value) }
  it { should_not allow_value(0).for(:value) }
  it { should_not allow_value(-23).for(:value) }

  context 'validate value' do
    before do
      subject.stub(:pledge).and_return(pledge)
    end

    let :pledge do
      double('Pledge', :balance => 3)
    end

    it 'should not be valid if value greater than pledge balance' do
      subject.should_not allow_value(4).for(:value).with_message("não pode ser superior ao saldo do empenho")
    end

    it 'should be valid if value is not greater than pledge balance' do
      subject.should allow_value(1).for(:value)
    end
  end

  context 'validate date' do
    before(:each) do
      described_class.stub(:last).and_return(double('PledgeLiquidation', :date => Date.new(2012, 3, 1)))
      described_class.stub(:any?).and_return(true)
    end

    it 'should be valid when date is equal to last' do
      subject.should allow_value(Date.new(2012, 3, 1)).for(:date)
    end

    it 'should not be valid when date is older to last' do
      subject.should_not allow_value(Date.new(2011, 1, 1)).for(:date).with_message('não pode ser menor que a data da última liquidação (01/03/2012)')
    end

    it 'should not be valid when date is older then emission_date' do
      subject.stub(:pledge).and_return(double('Pledge', :emission_date => Date.new(2012, 3, 29)))
      subject.should_not allow_value(Date.new(2012, 3, 1)).for(:date).with_message('deve ser maior que a data de emissão do empenho')
    end
  end

  context 'movimentable pledge_parcels' do
    before do
      subject.stub(:pledge).and_return(pledge)
    end

    let :pledge do
      double('Pledge', :pledge_parcels_with_balance => pledge_parcels)
    end

    let :pledge_parcels do
      [
        double('PledgeParcelOne', :balance => 100),
        double('PledgeParcelTwo', :balance => 100)
      ]
    end

    it 'should return pledge_parcels with balance' do
      subject.movimentable_pledge_parcels.should eq pledge_parcels
    end
  end
end
