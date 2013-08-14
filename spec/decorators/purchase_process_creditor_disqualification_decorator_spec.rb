require 'decorator_helper'
require 'enumerate_it'
require 'app/enumerations/purchase_process_creditor_disqualification_kind'
require 'app/decorators/purchase_process_creditor_disqualification_decorator'

describe PurchaseProcessCreditorDisqualificationDecorator do
  describe '#lot_kind_radio_collection' do
    it 'returns the radio button collection for lots' do
      expect(subject.lot_kind_radio_collection).to eql [['Lotes da proposta', 'partial'], ['Toda proposta', 'total']]
    end
  end
end
