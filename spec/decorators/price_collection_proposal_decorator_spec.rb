# encoding: UTF-8
require 'decorator_helper'
require 'app/decorators/price_collection_proposal_decorator'

describe PriceCollectionProposalDecorator do
  let :date do
    Date.new(2012, 12, 1)
  end

  context '#price_collection_date' do
    context 'when do not have price_collection_date' do
      before do
        component.stub(:price_collection_date).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.price_collection_date).to be_nil
      end
    end

    context 'when have price_collection_date' do
      before do
        component.stub(:price_collection_date).and_return(date)
      end

      it 'should localize' do
        expect(subject.price_collection_date).to eq '01/12/2012'
      end
    end
  end

  context '#item_total_value_by_lot' do
    context 'when do not have item_total_value_by_lot' do
      before do
        component.stub(:item_total_value_by_lot).with(1).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.item_total_value_by_lot(1)).to be_nil
      end
    end

    context 'when have item_total_value_by_lot' do
      before do
        component.stub(:item_total_value_by_lot).with(1).and_return(500.0)
      end

      it 'should applies precision' do
        expect(subject.item_total_value_by_lot(1)).to eq "500,00"
      end
    end
  end

  context '#only_creditor_is_authorized_message' do
    let(:user) { double('User') }

    it 'when user is not the creditor' do
      I18n.backend.store_translations 'pt-BR', :price_collection_proposal => {
          :messages => {
            :only_creditor_is_authorized => 'não pode'
        }
      }

      component.stub(:editable_by? => false)

      expect(subject.only_creditor_is_authorized_message(user)).to eq 'não pode'
    end

    it 'when user is the creditor' do
      component.stub(:editable_by? => true)

      expect(subject.only_creditor_is_authorized_message(user)).to be_nil
    end
  end

  describe '#code_and_year' do
    it 'should return price_collection_code and price_collection_year' do
      component.stub(:price_collection_code => 10)
      component.stub(:price_collection_year => 2013)

      expect(subject.code_and_year).to eq '10/2013'
    end
  end
end
