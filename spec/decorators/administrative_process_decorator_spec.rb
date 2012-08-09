# encoding: utf-8
require 'decorator_helper'
require 'active_support/core_ext/array/grouping'
require 'app/decorators/administrative_process_decorator'

describe AdministrativeProcessDecorator do
  context '#value_estimated' do
    context 'when do not have value_estimated' do
      before do
        subject.stub(:value_estimated).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.value_estimated).to be_nil
      end
    end

    context 'when have value_estimated' do
      before do
        component.stub(:value_estimated).and_return(500)
      end

      it 'should applies currency' do
        expect(subject.value_estimated).to eq 'R$ 500,00'
      end
    end
  end

  context '#total_allocations_value' do
    context 'when do not have total_allocations_value' do
      before do
        component.stub(:total_allocations_value).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.total_allocations_value).to be_nil
      end
    end

    context 'when have total_allocations_value' do
      before do
        component.stub(:total_allocations_value).and_return(400)
      end

      it 'should applies precision' do
        expect(subject.total_allocations_value).to eq '400,00'
      end
    end
  end

  context '#date' do
    context 'when do not have date' do
      before do
        component.stub(:date).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.date).to eq nil
      end
    end

    context 'when have date' do
      before do
        component.stub(:date).and_return(Date.new(2012, 12, 31))
      end

      it 'should localize' do
        expect(subject.date).to eq '31/12/2012'
      end
    end
  end
end
