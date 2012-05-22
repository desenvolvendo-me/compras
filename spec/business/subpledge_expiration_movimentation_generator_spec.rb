require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/subpledge_expiration_movimentation_calculator'
require 'app/business/subpledge_expiration_movimentation_generator'

describe SubpledgeExpirationMovimentationGenerator do
  subject do
    described_class.new(subpledge_cancellation_object, subpledge_expiration_movimentation_storage)
  end

  let :subpledge_expiration_movimentation_storage do
    double('SubpledgeExpirationMovimentationStorage')
  end

  let :subpledge_expiration_one do
    double('SubpledgeExpirationOne', :id => 1, :value => 100, :canceled_value => 0, :balance => 100)
  end

  let :subpledge_expiration_two do
    double('SubpledgeExpirationTwo', :id => 2, :value => 100, :canceled_value => 0, :balance => 100)
  end

  let :subpledge_object do
    double('SubpledgeStorage', :id => 3, :value => 200)
  end

  let :subpledge_cancellation_object do
    double(
      'SubpledgeCancellationStorage',
      :id => 4,
      :subpledge => subpledge_object,
      :class => double('SubpledgeCancellationStorage', :name => 'SubpledgeCancellation'),
      :movimentable_subpledge_expirations => [subpledge_expiration_one, subpledge_expiration_two]
    )
  end

  it 'cancel 90' do
    subpledge_cancellation_object.stub(:value).and_return(90)

    subpledge_expiration_movimentation_storage.should_receive(:create!).with(
      :subpledge_expiration_id => 1,
      :subpledge_expiration_modificator_id => 4,
      :subpledge_expiration_modificator_type => 'SubpledgeCancellation',
      :subpledge_expiration_value_was => 100,
      :subpledge_expiration_value => 10,
      :value => 90
    )

    subject.generate!
  end

  it 'cancel 150 using two subpledge expirations' do
    subpledge_cancellation_object.stub(:value).and_return(150)

    subpledge_expiration_movimentation_storage.should_receive(:create!).with(
      :subpledge_expiration_id => 1,
      :subpledge_expiration_modificator_id => 4,
      :subpledge_expiration_modificator_type => 'SubpledgeCancellation',
      :subpledge_expiration_value_was => 100,
      :subpledge_expiration_value => 0,
      :value => 100
    )

    subpledge_expiration_movimentation_storage.should_receive(:create!).with(
      :subpledge_expiration_id => 2,
      :subpledge_expiration_modificator_id => 4,
      :subpledge_expiration_modificator_type => 'SubpledgeCancellation',
      :subpledge_expiration_value_was => 100,
      :subpledge_expiration_value => 50,
      :value => 50
    )

    subject.generate!
  end

  it 'cancel 50 after already canceled 90' do
    subpledge_cancellation_object.stub(:value).and_return(50)
    subpledge_expiration_one.stub(:balance).and_return(10)
    subpledge_cancellation_object.stub(:movimentable_subpledge_expirations).and_return([subpledge_expiration_one, subpledge_expiration_two])

    subpledge_expiration_movimentation_storage.should_receive(:create!).with(
      :subpledge_expiration_id => 1,
      :subpledge_expiration_modificator_id => 4,
      :subpledge_expiration_modificator_type => 'SubpledgeCancellation',
      :subpledge_expiration_value_was => 10,
      :subpledge_expiration_value => 0,
      :value => 10
    )

    subpledge_expiration_movimentation_storage.should_receive(:create!).with(
      :subpledge_expiration_id => 2,
      :subpledge_expiration_modificator_id => 4,
      :subpledge_expiration_modificator_type => 'SubpledgeCancellation',
      :subpledge_expiration_value_was => 100,
      :subpledge_expiration_value => 60,
      :value => 40
    )

    subject.generate!
  end
end
