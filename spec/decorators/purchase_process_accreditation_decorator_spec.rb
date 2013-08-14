require 'decorator_helper'
require 'app/decorators/purchase_process_accreditation_decorator'

describe PurchaseProcessAccreditationDecorator do
  describe '#must_have_creditors' do
    I18n.backend.store_translations 'pt-BR', :purchase_process_accreditation => {
      :messages => { :must_have_creditors => 'Inclua algum credor primeiro' }
    }

    context 'when have creditors' do
      before { component.stub(:creditors).and_return([double(:creditors)]) }

      it { expect(subject.must_have_creditors).to be_nil }
    end

    context 'when have not creditors' do
      before { component.stub(:creditors).and_return([]) }

      it 'should return "Inclua algum credor primeiro"' do
        expect(subject.must_have_creditors).to eq "Inclua algum credor primeiro"
      end
    end
  end

  describe '#company_sizes' do
    let(:company_size_repository) { double(:company_size_class) }

    it 'should return all company sizes' do
      company_size_repository.should_receive(:all)

      subject.company_sizes(company_size_repository)
    end
  end
end
