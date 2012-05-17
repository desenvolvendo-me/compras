require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/pledge_parcel_movimentation_calculator'
require 'app/business/pledge_parcel_movimentation_generator'

describe PledgeParcelMovimentationGenerator do
  subject do
    described_class.new(pledge_cancellation_object, pledge_parcel_movimentation_storage)
  end

  context 'create based on balance' do
    let :pledge_parcel_movimentation_storage do
      double('PledgeParcelMovimentationStorage')
    end

    let :pledge_parcel_one do
      double('PledgeParcelOne', :id => 1, :value => 100, :canceled_value => 0, :balance => 100)
    end

    let :pledge_parcel_two do
      double('PledgeParcelTwo', :id => 2, :value => 100, :canceled_value => 0, :balance => 100)
    end

    let :pledge_object do
      double('PledgeStorage', :id => 3, :value => 200, :pledge_parcels_with_balance => [pledge_parcel_one, pledge_parcel_two])
    end

    let :pledge_cancellation_object do
      double('PledgeCancellationStorage', :id => 4, :pledge => pledge_object, :class => double('PledgeCancellationStorage', :name => 'PledgeCancellation'))
    end

    it 'cancel 90' do
      pledge_cancellation_object.stub(:value).and_return(90)

      pledge_parcel_movimentation_storage.should_receive(:create!).with(
        :pledge_parcel_id => 1,
        :pledge_parcel_modificator_id => 4,
        :pledge_parcel_modificator_type => 'PledgeCancellation',
        :pledge_parcel_value_was => 100,
        :pledge_parcel_value => 10,
        :value => 90
      )

      subject.generate!
    end

    it 'cancel 150 using two parcels' do
      pledge_cancellation_object.stub(:value).and_return(150)

      pledge_parcel_movimentation_storage.should_receive(:create!).with(
        :pledge_parcel_id => 1,
        :pledge_parcel_modificator_id => 4,
        :pledge_parcel_modificator_type => 'PledgeCancellation',
        :pledge_parcel_value_was => 100,
        :pledge_parcel_value => 0,
        :value => 100
      )

      pledge_parcel_movimentation_storage.should_receive(:create!).with(
        :pledge_parcel_id => 2,
        :pledge_parcel_modificator_id => 4,
        :pledge_parcel_modificator_type => 'PledgeCancellation',
        :pledge_parcel_value_was => 100,
        :pledge_parcel_value => 50,
        :value => 50
      )

      subject.generate!
    end

    it 'cancel 50 after already canceled 90' do
      pledge_cancellation_object.stub(:value).and_return(50)
      pledge_parcel_one.stub(:balance).and_return(10)
      pledge_object.stub(:pledge_parcels_with_balance).and_return([pledge_parcel_one, pledge_parcel_two])

      pledge_parcel_movimentation_storage.should_receive(:create!).with(
        :pledge_parcel_id => 1,
        :pledge_parcel_modificator_id => 4,
        :pledge_parcel_modificator_type => 'PledgeCancellation',
        :pledge_parcel_value_was => 10,
        :pledge_parcel_value => 0,
        :value => 10
      )

      pledge_parcel_movimentation_storage.should_receive(:create!).with(
        :pledge_parcel_id => 2,
        :pledge_parcel_modificator_id => 4,
        :pledge_parcel_modificator_type => 'PledgeCancellation',
        :pledge_parcel_value_was => 100,
        :pledge_parcel_value => 60,
        :value => 40
      )

      subject.generate!
    end
  end

  context 'create based on liquidation' do
    let :pledge_parcel_movimentation_storage do
      double('PledgeParcelMovimentationStorage')
    end

    let :pledge_parcel_one do
      double('PledgeParcelOne', :id => 1, :value => 100, :canceled_value => 0, :liquidations_value => 100)
    end

    let :pledge_parcel_two do
      double('PledgeParcelTwo', :id => 2, :value => 100, :canceled_value => 0, :liquidations_value => 100)
    end

    let :pledge_object do
      double('PledgeStorage', :id => 3, :value => 200, :pledge_parcels_with_liquidations => [pledge_parcel_one, pledge_parcel_two])
    end

    let :pledge_cancellation_object do
      double('PledgeLiquidationCancellationStorage', :id => 4, :pledge => pledge_object, :class => double('PledgeLiquidationCancellationClass', :name => 'PledgeLiquidationCancellation'))
    end

    it 'cancel 90' do
      pledge_cancellation_object.stub(:value).and_return(90)

      pledge_parcel_movimentation_storage.should_receive(:create!).with(
        :pledge_parcel_id => 1,
        :pledge_parcel_modificator_id => 4,
        :pledge_parcel_modificator_type => 'PledgeLiquidationCancellation',
        :pledge_parcel_value_was => 100,
        :pledge_parcel_value => 10,
        :value => 90
      )

      subject.generate!
    end

    it 'cancel 150 using two parcels' do
      pledge_cancellation_object.stub(:value).and_return(150)

      pledge_parcel_movimentation_storage.should_receive(:create!).with(
        :pledge_parcel_id => 1,
        :pledge_parcel_modificator_id => 4,
        :pledge_parcel_modificator_type => 'PledgeLiquidationCancellation',
        :pledge_parcel_value_was => 100,
        :pledge_parcel_value => 0,
        :value => 100
      )

      pledge_parcel_movimentation_storage.should_receive(:create!).with(
        :pledge_parcel_id => 2,
        :pledge_parcel_modificator_id => 4,
        :pledge_parcel_modificator_type => 'PledgeLiquidationCancellation',
        :pledge_parcel_value_was => 100,
        :pledge_parcel_value => 50,
        :value => 50
      )

      subject.generate!
    end

    it 'cancel 50 after already canceled 90' do
      pledge_cancellation_object.stub(:value).and_return(50)
      pledge_parcel_one.stub(:liquidations_value).and_return(10)
      pledge_object.stub(:pledge_parcels_with_liquidations).and_return([pledge_parcel_one, pledge_parcel_two])

      pledge_parcel_movimentation_storage.should_receive(:create!).with(
        :pledge_parcel_id => 1,
        :pledge_parcel_modificator_id => 4,
        :pledge_parcel_modificator_type => 'PledgeLiquidationCancellation',
        :pledge_parcel_value_was => 10,
        :pledge_parcel_value => 0,
        :value => 10
      )

      pledge_parcel_movimentation_storage.should_receive(:create!).with(
        :pledge_parcel_id => 2,
        :pledge_parcel_modificator_id => 4,
        :pledge_parcel_modificator_type => 'PledgeLiquidationCancellation',
        :pledge_parcel_value_was => 100,
        :pledge_parcel_value => 60,
        :value => 40
      )

      subject.generate!
    end
  end
end
