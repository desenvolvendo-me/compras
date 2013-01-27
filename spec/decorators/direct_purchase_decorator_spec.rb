# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/direct_purchase_decorator'

describe DirectPurchaseDecorator do
  context '#total_allocations_item_value' do
    context 'when do not have total_allocations_item_value' do
      before do
        component.stub(:total_allocations_items_value).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.total_allocations_items_value).to be_nil
      end
    end

    context 'when have total_allocations_items_value' do
      before do
        component.stub(:total_allocations_items_value).and_return(512.34)
      end

      it 'should applies precision' do
        expect(subject.total_allocations_items_value).to eq '512,34'
      end
    end
  end

  context '#is_annulled_message' do
    it 'when is annulled' do
      I18n.backend.store_translations 'pt-BR', :direct_purchase => {
          :messages => {
            :is_annulled => 'não pode'
        }
      }

      component.stub(:annulled? => true)

      expect(subject.is_annulled_message).to eq 'não pode'
    end

    it 'when is not annulled' do
      component.stub(:annulled? => false)

      expect(subject.is_annulled_message).to be_nil
    end
  end

  describe '#code_and_year' do
    before { component.stub(:code => 1, :year => 2012) }

    it "return code/year to #code_and_year " do
      expect(subject.code_and_year).to eq "1/2012"
    end
  end
end
