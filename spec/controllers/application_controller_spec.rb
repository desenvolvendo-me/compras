require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      render :nothing => true
    end
  end

  it 'should not handle customer connection on test environment' do
    Rails.should_receive(:env).and_return(ActiveSupport::StringInquirer.new('test'))

    Customer.should_receive(:find_by_domain!).never

    get :index
  end

  it 'should not handle customer connection on development environment' do
    Rails.should_receive(:env).and_return(ActiveSupport::StringInquirer.new('development'))

    Customer.should_receive(:find_by_domain!).never

    get :index
  end

  it 'should handle customer connection on production environment' do
    Rails.should_receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))

    customer = double('customer')
    customer.should_receive(:using_connection)

    Customer.should_receive(:find_by_domain!).with('test.host').and_return(customer)

    get :index
  end
end
