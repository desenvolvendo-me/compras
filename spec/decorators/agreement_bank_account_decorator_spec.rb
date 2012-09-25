require 'decorator_helper'
require 'app/decorators/agreement_bank_account_decorator'

describe AgreementBankAccountDecorator do
  context 'when have creation_date' do
    before do
      component.stub(:creation_date).and_return(Date.new(2012, 9, 20))
    end

    it 'should localize' do
      expect(subject.creation_date).to eq '20/09/2012'
    end
  end

  context 'when have not creation_date' do
    before do
      component.stub(:creation_date).and_return(nil)
    end

    let :date_repository do
      double('DateRepository', :current => Date.new(2012, 9, 20))
    end

    it 'should localize Date.current' do
      expect(subject.creation_date(date_repository)).to eq '20/09/2012'
    end
  end
end
