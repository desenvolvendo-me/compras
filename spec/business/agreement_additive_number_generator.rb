require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/agreement_additive_number_generator'

describe AgreementAdditiveNumberGenerator do
  context 'when have all additives as unpersisted' do
    let :additive_one do
      double('AdditiveOne', :persisted? => false, :number => nil, :marked_for_destruction? => false)
    end

    let :additive_two do
      double('AdditiveTwo', :persisted? => false, :number => nil, :marked_for_destruction? => false)
    end

    let :agreement do
      double('AgreementWithTwoAdditives',
             :agreement_additives => [additive_one, additive_two],
             :last_additive_number => 0)
    end

    it 'should set number to additives' do
      additive_one.should_receive(:number=).with(1)
      additive_two.should_receive(:number=).with(2)

      described_class.new(agreement).generate!
    end
  end

  context 'when have one persisted additive and a non persisted' do
    let :additive_one do
      double('AdditiveOne', :persisted? => true, :number => 1, :marked_for_destruction? => false)
    end

    let :additive_two do
      double('AdditiveTwo', :persisted? => false, :number => nil, :marked_for_destruction? => false)
    end

    let :agreement do
      double('AgreementWithTwoAdditives',
             :agreement_additives => [additive_one, additive_two],
             :last_additive_number => 1)
    end

    it 'should set number to additives' do
      additive_one.should_not_receive(:number=)
      additive_two.should_receive(:number=).with(2)

      described_class.new(agreement).generate!
    end
  end

  context 'when have a deleted additive, a non persisted and a persisted' do
    let :additive_one do
      double('AdditiveOne', :persisted? => true, :number => 2, :marked_for_destruction? => false)
    end

    let :additive_two do
      double('AdditiveTwo', :persisted? => false, :number => nil, :marked_for_destruction? => false)
    end

    let :agreement do
      double('AgreementWithTwoAdditives',
             :agreement_additives => [additive_one, additive_two],
             :last_additive_number => 2)
    end

    it 'should set number to additives' do
      additive_one.should_not_receive(:number=)
      additive_two.should_receive(:number=).with(3)

      described_class.new(agreement).generate!
    end
  end
end
