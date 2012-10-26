# encoding: utf-8
require 'spec_helper'

describe Descriptor do
  it 'should validate uniqueness of entity' do
    Descriptor.make!(:detran_2012)

    expect(subject).to validate_uniqueness_of(:entity_id).scoped_to(:period).
      with_message(:taken_for_informed_period)
  end

  describe '.by_year' do
    it 'should found only of 2011' do
      detran_2011 = Descriptor.make!(:detran_2011)
      Descriptor.make!(:detran_2012)

      expect(Descriptor.by_year(2011)).to eq [detran_2011]
    end
  end

  describe '.filter' do
    it 'should found only of 2011' do
      detran_2011 = Descriptor.make!(:detran_2011)
      Descriptor.make!(:detran_2012)

      expect(Descriptor.filter(:year => "2011")).to eq [detran_2011]
    end

    it 'should found only of detran' do
      detran = Descriptor.make!(:detran_2011)
      Descriptor.make!(:secretaria_de_educacao_2012)

      expect(Descriptor.filter(:entity_id => detran.entity_id)).to eq [detran]
    end

    it 'should found only of Dentra 2011' do
      detran_2011 = Descriptor.make!(:detran_2011)
      Descriptor.make!(:detran_2012)
      Descriptor.make!(:secretaria_de_educacao_2012)

      expect(Descriptor.filter(:entity_id => detran_2011.entity_id,
                               :year => '2011')).to eq [detran_2011]
    end
  end
end
