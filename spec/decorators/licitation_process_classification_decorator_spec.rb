# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_process_classification_decorator'

describe LicitationProcessClassificationDecorator do
  context '#unit_value' do
    context 'when do not have unit_value' do
      before do
        component.stub(:unit_value).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.unit_value).to be_nil
      end
    end

    context 'when have unit_value' do
      before do
        component.stub(:unit_value).and_return(50.0)
      end

      it 'should applies precision' do
        expect(subject.unit_value).to eq '50,00'
      end
    end
  end

  context '#total_value' do
    context 'when have total_value' do
      before do
        component.stub(:total_value).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.total_value).to be_nil
      end
    end

    context 'when have total_value' do
      before do
        component.stub(:total_value).and_return(80.0)
      end

      it 'should applies precision' do
        expect(subject.total_value).to eq '80,00'
      end
    end
  end
end
