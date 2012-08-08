# encoding: utf-8
require 'model_helper'
require 'app/models/pledge_liquidation'
require 'app/models/pledge_liquidation_parcel'
require 'lib/annullable'
require 'app/models/resource_annul'

describe PledgeLiquidation do
  it 'should return id as to_s' do
    subject.id = 1
    expect(subject.to_s).to eq '1'
  end

  it { should validate_presence_of :pledge }
  it { should validate_presence_of :value }
  it { should validate_presence_of :date }

  it { should validate_numericality_of :value }

  it { should belong_to :pledge }

  it { should have_one(:annul).dependent(:destroy) }
  it { should have_many(:pledge_liquidation_parcels).dependent(:destroy).order(:number) }

  context 'validate value' do
    before do
      subject.stub(:decorator).and_return(double(:value => 'R$ 0,00'))
    end

    it { should allow_value(23).for(:value) }
    it { should_not allow_value(0).for(:value) }
    it { should_not allow_value(-23).for(:value) }
  end

  context 'validate value' do
    before do
      subject.stub(:pledge).and_return(pledge)
      subject.stub(:decorator).and_return(double(:value => 'R$ 100,00'))
    end

    let :pledge do
      double('Pledge', :balance => 3.0)
    end

    it 'should not be valid if value greater than pledge balance' do
      expect(subject).not_to allow_value(4).for(:value).with_message("não pode ser superior ao saldo do empenho (R$ 3,00)")
    end

    it 'should be valid if value is not greater than pledge balance' do
      expect(subject).to allow_value(1).for(:value)
    end
  end

  context 'validate date' do
    before(:each) do
      described_class.stub(:last).and_return(double('PledgeLiquidation', :date => Date.new(2012, 3, 1)))
      described_class.stub(:any?).and_return(true)
    end

    it 'should be valid when date is equal to last' do
      expect(subject).to allow_value(Date.new(2012, 3, 1)).for(:date)
    end

    it 'should not be valid when date is older to last' do
      expect(subject).not_to allow_value(Date.new(2011, 1, 1)).for(:date).with_message('não pode ser menor que a data da última liquidação (01/03/2012)')
    end

    it 'should not be valid when date is older then emission_date' do
      subject.stub(:pledge).and_return(double('Pledge', :emission_date => Date.new(2012, 3, 29)))
      expect(subject).not_to allow_value(Date.new(2012, 3, 1)).for(:date).with_message('deve ser maior que a data de emissão do empenho (29/03/2012)')
    end
  end

  context 'parcels_sum' do
    let :parcels do
      [
        double('ParcelOne', :value => 10),
        double('ParcelTwo', :value => 90)
      ]
    end

    it 'should return correct parcels_sum' do
      subject.stub(:pledge_liquidation_parcels).and_return(parcels)
      expect(subject.parcels_sum).to eq 100
    end
  end
end
