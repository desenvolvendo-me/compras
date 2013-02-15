require 'unit_helper'
require 'app/business/customer_finder'

describe CustomerFinder do
  subject do
    described_class.new(customer_domain,
                        :customer_repository => customer_repository,
                        :nil_customer_repository => nil_customer_repository)
  end

  let(:customer_repository) { double(:customer_repository) }
  let(:nil_customer_repository) { double(:nil_customer_repository) }

  let(:customer_domain) { 'localhost' }

  describe '#current_customer' do
    context 'when find a customer by domain' do
      it 'should return the customer' do
        customer_repository.should_receive(:find_by_domain).with('localhost').and_return('customer')

        expect(subject.current_customer).to eq 'customer'
      end
    end

    context 'when find a customer by domain' do
      it 'should return the customer' do
        customer_repository.should_receive(:find_by_domain).with('localhost').and_return(nil)
        nil_customer_repository.should_receive(:new).and_return('nil_customer')

        expect(subject.current_customer).to eq 'nil_customer'
      end
    end
  end

  describe '.current' do
    let(:new_instance) { double(:new_instance) }

    it 'should return a new instance and call current_customer' do
      described_class.should_receive(:new).with(
        customer_domain,
        :customer_repository => customer_repository,
        :nil_customer_repository => nil_customer_repository
      ).and_return(new_instance)

      new_instance.should_receive(:current_customer)

      described_class.current(customer_domain,
        :customer_repository => customer_repository,
        :nil_customer_repository => nil_customer_repository)
    end
  end
end
