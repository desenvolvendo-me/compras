require 'unit_helper'
require 'lib/main_controller_getter'

describe MainControllerGetter do
  let(:permissions_path) { 'spec/fixtures/permissions.yml' }

  it 'should found the delegated permission to contracts' do
    subject = MainControllerGetter.new('trading_items', permissions_path)

    expect(subject.name).to eq('tradings')
  end

  it 'should not found a delegated permission' do
    subject = MainControllerGetter.new('tradings', permissions_path)

    expect(subject.name).to eq('tradings')
  end
end
