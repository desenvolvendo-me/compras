require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      render :nothing => true
    end
  end

  let(:customer) { double('customer').as_null_object }

  context 'when found a customer' do
    it 'should handle customer connection' do
      customer.should_receive(:using_connection)

      request.env['X-Customer'] = 'ipatinga-mg'

      Customer.should_receive(:find_by_domain).
               with('ipatinga-mg').
               and_return(customer)

      get :index
    end
  end

  context 'when do not found a customer' do
    it 'should handle customer connection' do
      NilCustomer.any_instance.should_receive(:using_connection)

      request.env['X-Customer'] = 'ipatinga-mg'

      Customer.should_receive(:find_by_domain).
               with('ipatinga-mg').
               and_return(nil)

      get :index
    end
  end

  it 'should set the current domain to Uploader' do
    customer.stub(:domain).and_return('url')

    Customer.stub(:find_by_domain).and_return(customer)

    get :index

    expect(Uploader.current_domain).to eq('url')
  end

  it 'should return current prefecture' do
    Prefecture.should_receive(:last)

    subject.current_prefecture
  end

  describe '#render_to_pdf' do
    it 'should render_partial to pdf' do
      subject.should_receive(:render_to_string).
              with(:partial => 'partial', :locals => { :resource => true }).
              and_return('html')

      PDFKit.any_instance.should_receive(:to_pdf).and_return('PDF')

      expect(subject.render_to_pdf('partial', :locals => { :resource => true })).to eq 'PDF'
    end
  end
end
