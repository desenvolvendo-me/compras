# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/agreement_decorator'

describe AgreementDecorator do
  context '#creation_date' do
    context 'when do not have creation_date' do
      before do
        component.stub(:creation_date).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.creation_date).to be_nil
      end
    end

    context 'when have creation_date' do
      before do
        component.stub(:creation_date).and_return(Date.new(2012, 12, 31))
      end

      it 'should localize' do
        expect(subject.creation_date).to eq '31/12/2012'
      end
    end
  end

  context '#publication_date' do
    context 'when do not have publication_date' do
      before do
        component.stub(:publication_date).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.publication_date).to be_nil
      end
    end

    context 'when have publication_date' do
      before do
        component.stub(:publication_date).and_return(Date.new(2012, 12, 31))
      end

      it 'should localize' do
        expect(subject.publication_date).to eq '31/12/2012'
      end
    end
  end

  context '#end_date' do
    context 'when do not have end_date' do
      before do
        component.stub(:end_date).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.end_date).to be_nil
      end
    end

    context 'when have end_date' do
      before do
        component.stub(:end_date).and_return(Date.new(2012, 12, 31))
      end

      it 'should localize' do
        expect(subject.end_date).to eq '31/12/2012'
      end
    end
  end
end
