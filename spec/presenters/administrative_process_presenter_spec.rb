# encoding: utf-8
require 'presenter_helper'
require 'app/presenters/administrative_process_presenter'

describe AdministrativeProcessPresenter do
  subject do
    described_class.new(administrative_process, nil, helpers)
  end

  let :helpers do
    double 'helpers'
  end

  context '#value_estimated' do
    let :administrative_process do
      double(:value_estimated => 500)
    end


    it 'should return formatted value_estimated' do
      helpers.stub(:number_to_currency).with(500).and_return('R$ 500,00')
      subject.stub(:value_estimated).and_return(500)

      subject.value_estimated.should eq 'R$ 500,00'
    end
  end

  context '#total_allocations_value' do
    let :administrative_process do
      double(:total_allocations_value => 400)
    end

    it 'should return formatted total_allocations_value' do
      helpers.stub(:number_with_precision).with(400).and_return('400,00')

      subject.total_allocations_value.should eq '400,00'
    end
  end
end
