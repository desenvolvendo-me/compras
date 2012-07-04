require 'unit_helper'
require 'app/business/profile_updater'

describe ProfileUpdater do
  let :customers_role do
    mock('role', :controller => 'customers')
  end

  let :contacts_role do
    mock('role', :controller => 'contacts')
  end

  let :profile do
    mock('profile')
  end

  let :permission do
    mock('permission')
  end

  let :i18n do
    mock('I18n', :translate => { :customers => "Customers" })
  end

  it 'do not duplicate existent roles' do
    profile.stub(:roles).and_return([customers_role])
    profile.should_receive(:build_role).never

    profile_updater = ProfileUpdater.new(profile, permission, i18n)
    profile_updater.update
  end

  it 'should create inexistent roles' do
    profile.stub(:roles).and_return([])
    profile.should_receive(:build_role).with(:controller => 'customers', :permission => permission)

    profile_updater = ProfileUpdater.new(profile, permission, i18n)
    profile_updater.update
  end

  it 'should destroy left roles' do
    profile.should_receive(:delete_role).with(contacts_role)
    profile.stub(:roles).and_return([customers_role, contacts_role])

    profile_updater = ProfileUpdater.new(profile, permission, i18n)
    profile_updater.update
  end
end
