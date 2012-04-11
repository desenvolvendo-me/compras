# encoding: utf-8
require 'presenter_helper'
require 'app/presenters/administrative_process_presenter'

describe AdministrativeProcessPresenter do
  subject do
    described_class.new(administrative_process, nil, helpers)
  end

  let :administrative_process do
    double(:value_estimated => 500)
  end

  let :helpers do
    double.tap do |helpers|
      helpers.stub(:number_to_currency).with(500).and_return('R$ 500,00')
      helpers.stub(:number_with_precision).with(400).and_return('400,00')
    end
  end

  it 'should return formatted value_estimated' do
    subject.stub(:value_estimated).and_return(500)
    subject.value_estimated.should eq 'R$ 500,00'
  end

  it 'should return formatted total_allocations_value' do
    subject.stub(:total_allocations_value).and_return(400.0)
    subject.total_allocations_value.should eq '400,00'
  end
end
