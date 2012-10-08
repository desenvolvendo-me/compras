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

  it 'should return current prefecture' do
    Prefecture.should_receive(:last)

    subject.current_prefecture
  end

  it 'should return root_url' do
    expect(subject.root_url).to eq 'http://test.host'
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
