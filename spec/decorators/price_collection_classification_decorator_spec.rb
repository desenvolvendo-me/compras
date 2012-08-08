# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/price_collection_classification_decorator'

describe PriceCollectionClassificationDecorator do
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

  context '#classification' do
    before do
      I18n.backend.store_translations 'pt-BR', :true => 'Sim'
      I18n.backend.store_translations 'pt-BR', :false => 'Não'
    end

    context 'when is true' do
      before do
        component.stub(:classification).and_return(1)
      end

      it 'should localize true when is equals to 1' do
        expect(subject.classification).to eq 'Sim'
      end
    end

    context 'when is false' do
      before do
        component.stub(:classification).and_return(2)
      end

      it 'should localize false when is not equals to 1' do
        expect(subject.classification).to eq 'Não'
      end
    end

    context 'when is nil' do
      before do
        component.stub(:classification).and_return(nil)
      end

      it 'should localize false when is not equals to 1' do
        expect(subject.classification).to eq 'Não'
      end
    end
  end
end
