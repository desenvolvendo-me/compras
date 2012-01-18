require 'unit_helper'
require 'app/business/link_updater'

describe LinkUpdater do
  let :customers_link do
    mock('link', :controller_name => 'customers')
  end

  let :contacts_link do
    mock('link', :controller_name => 'contacts')
  end

  let :link_store do
    mock('Link')
  end

  let :i18n do
    mock('I18n', :translate => { :customers => "Customers" })
  end

  it 'do not duplicate existent links' do
    link_store.stub(:all).and_return([customers_link])
    link_store.should_receive(:create!).never

    link_updater = LinkUpdater.new(link_store, i18n)
    link_updater.update!
  end

  it 'should create inexistent links' do
    link_store.stub(:all).and_return([])
    link_store.should_receive(:create!).with(:controller_name => 'customers')

    link_updater = LinkUpdater.new(link_store, i18n)
    link_updater.update!
  end

  it 'should destroy left links' do
    contacts_link.should_receive(:destroy)
    link_store.stub(:all).and_return([customers_link, contacts_link])

    link_updater = LinkUpdater.new(link_store, i18n)
    link_updater.update!
  end
end
