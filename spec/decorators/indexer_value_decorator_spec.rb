require 'decorator_helper'
require 'app/decorators/indexer_value_decorator'

describe IndexerValueDecorator do
  describe '#value' do
    before do
      component.stub(:value).and_return(12.12)
      component.stub(:scale_of_value).and_return(6)
      helpers.stub(:number_with_precision).with(12.12, :precision => component.scale_of_value).and_return('12,120000')
    end

    it 'should applies precision with 6 of scale' do
      subject.value.should eq '12,120000'
    end
  end
end
