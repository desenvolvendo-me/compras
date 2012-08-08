require 'decorator_helper'
require 'app/decorators/revenue_nature_decorator'

describe RevenueNatureDecorator do
  context '#publication_date' do
    context 'when have publication_date' do
      before do
        component.stub(:publication_date).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.publication_date).to be_nil
      end
    end

    context 'when have publication_date' do
      before do
        component.stub(:publication_date).and_return(Date.new(2012, 12, 15))
      end

      it 'should localize' do
        expect(subject.publication_date).to eq '15/12/2012'
      end
    end
  end
end
