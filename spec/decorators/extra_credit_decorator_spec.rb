# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/extra_credit_decorator'

describe ExtraCreditDecorator do
  context '#publication_date' do
    context 'when do not have publication_date' do
      before do
        component.stub(:publication_date).and_return(nil)
      end

      it 'should be nil' do
        subject.publication_date.should be_nil
      end
    end

    context 'when have publication_date' do
      before do
        component.stub(:publication_date).and_return(Date.new(2012, 3, 23))
      end

      it 'should localize' do
        subject.publication_date.should eq '23/03/2012'
      end
    end
  end
end
