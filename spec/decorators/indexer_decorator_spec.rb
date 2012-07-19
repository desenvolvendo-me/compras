require 'decorator_helper'
require 'app/decorators/indexer_decorator'

describe IndexerDecorator do
  context '#summary' do
    before do
      component.stub(:currency).and_return('Real')
    end

    it 'uses currency' do
      subject.summary.should eq 'Real'
    end
  end
end
