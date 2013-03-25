require 'unit_helper'
require 'app/business/customer_finder'

describe CustomerFinder do
  subject do
    described_class.new(request_double,
                        :customer_repository => customer_repository)
  end

  let(:customer_repository) { double(:customer_repository) }

  let(:request_double) { double(:request_double, :host => 'localhost') }

  let(:headers) { Hash.new }

  describe '#current_customer' do
    context 'when find a customer by domain' do
      it 'should return the customer' do
        headers['X-Customer'] = 'customer'
        request_double.stub(:headers).and_return(headers)
        customer_repository.should_receive(:find_by_domain!).with('customer').and_return('customer')

        expect(subject.current_customer).to eq 'customer'
      end
    end

    context 'when not find a customer by domain' do
      it 'should return the host request' do
        request_double.stub(:headers).and_return(headers)
        customer_repository.should_receive(:find_by_domain!).with('localhost').and_return('localhost')

        expect(subject.current_customer).to eq 'localhost'
      end
    end
  end

  describe '.current' do
    let(:new_instance) { double(:new_instance) }

    it 'should return a new instance and call current_customer' do
      described_class.should_receive(:new).with(
        request_double,
        :customer_repository => customer_repository
      ).and_return(new_instance)

      new_instance.should_receive(:current_customer)

      described_class.current(request_double,
        :customer_repository => customer_repository)
    end
  end
end
