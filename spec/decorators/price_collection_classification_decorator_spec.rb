# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/price_collection_classification_decorator'

describe PriceCollectionClassificationDecorator do
  context '#unit_value' do
    before do
      component.stub(:unit_value).and_return(50.0)
    end

    it 'should applies precision' do
      subject.unit_value.should eq '50,00'
    end
  end

  context '#total_value' do
    before do
      component.stub(:total_value).and_return(80.0)
    end

    it 'should applies precision' do
      subject.total_value.should eq '80,00'
    end
  end

  context '#classification' do
    before do
      I18n.backend.store_translations 'pt-BR', :true => 'Sim'
      I18n.backend.store_translations 'pt-BR', :false => 'Não'
    end

    it 'should localize true when is equals to 1' do
      component.stub(:classification => 1)

      subject.classification.should eq 'Sim'
    end

    it 'should localize false when is not equals to 1' do
      component.stub(:classification => 2)

      subject.classification.should eq 'Não'
    end
  end
end
