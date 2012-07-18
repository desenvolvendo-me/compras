require 'unit_helper'
require 'app/business/settings_updater'

describe SettingsUpdater do
  subject do
    SettingsUpdater.new(repository, i18n)
  end

  let :repository do
    double('Storage')
  end

  let :i18n do
    double('I18n')
  end

  it "should create missing settings" do
    i18n.should_receive(:translate).with(:settings).and_return(:default_city => 'City')

    repository.should_receive(:transaction).and_yield
    repository.should_receive(:find_or_create_by_key).with("default_city")

    subject.update
  end
end
