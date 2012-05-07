# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/administrative_process_decorator'

describe AdministrativeProcessDecorator do
  context '#value_estimated' do
    it 'should return formatted value_estimated' do
      component.stub(:value_estimated).and_return(500)
      helpers.stub(:number_to_currency).with(500).and_return('R$ 500,00')

      subject.value_estimated.should eq 'R$ 500,00'
    end
  end

  context '#total_allocations_value' do
    it 'should return formatted total_allocations_value' do
      component.stub(:total_allocations_value).and_return(400)
      helpers.stub(:number_with_precision).with(400).and_return('400,00')

      subject.total_allocations_value.should eq '400,00'
    end
  end
end
