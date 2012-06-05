require 'decorator_helper'
require 'app/decorators/indexer_decorator'

describe IndexerDecorator do
  context '#summary' do
    let :component do
      double(:currency => 'Real')
    end

    it 'uses currency' do
      subject.summary.should eq 'Real'
    end
  end
end
