require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      render :nothing => true
    end
  end

  let(:customer) { double('customer').as_null_object }

  it 'should handle customer connection' do
    customer.should_receive(:using_connection)

    request.env['X-Customer'] = 'ipatinga-mg'

    Customer.should_receive(:find_by_domain!).
      with('ipatinga-mg').
      and_return(customer)

    get :index
  end

  it 'should set the current domain to Uploader' do
    customer.stub(:domain).and_return('url')

    Customer.stub(:find_by_domain!).and_return(customer)

    get :index

    expect(Uploader.current_domain).to eq('url')
  end

  it 'should return current prefecture' do
    Prefecture.should_receive(:last)

    subject.current_prefecture
  end
end
