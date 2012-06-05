require 'decorator_helper'
require 'app/decorators/indexer_value_decorator'

describe IndexerValueDecorator do
  describe '#value' do
    let :component do
      double('Component', :value => 12.12)
    end

    it 'should return the number using precision 6' do
      helpers.stub(:number_with_precision).with(12.12, :precision => 6).and_return('12,12')

      subject.value.should eq '12,12'
    end
  end
end
