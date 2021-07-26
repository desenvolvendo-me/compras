require 'spec_helper'

describe ReserveFundRequestsHelper do
  describe '#reserve_fund_action' do
    let(:purchase_process) { double(:purchase_process) }

    context 'when purchase process does no have reserve funds' do
      it "should return 'Criar'" do
        purchase_process.should_receive(:reserve_funds).and_return([])

        expect(helper.reserve_fund_action(purchase_process)).to eq 'Criar'
      end
    end

    context 'when purchase process have reserve funds' do
      it "should return 'Editar'" do
        purchase_process.should_receive(:reserve_funds).and_return(['reserve_fund'])

        expect(helper.reserve_fund_action(purchase_process)).to eq 'Editar'
      end
    end
  end
end
