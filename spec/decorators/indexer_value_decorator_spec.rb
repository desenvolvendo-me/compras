require 'decorator_helper'
require 'app/decorators/indexer_value_decorator'

describe IndexerValueDecorator do
  describe '#value' do
    context 'when do not have value' do
      before do
        component.stub(:value).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.value).to be_nil
      end
    end

    context 'when have value' do
      before do
        component.stub(:value).and_return(12.12)
        component.stub(:scale_of_value).and_return(6)
      end

      it 'should applies precision with 6 of scale' do
        expect(subject.value).to eq '12,120000'
      end
    end
  end
end
