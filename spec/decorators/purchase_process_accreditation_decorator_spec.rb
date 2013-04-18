# encoding: utf-8
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
end
describe PurchaseProcessAccreditationDecorator do
  describe '#accreditation_path' do
    let(:routes) { double(:routes) }

    context 'when is persisted' do
      before { component.stub(:persisted? => true, :component => double(:id => 1)) }

      it 'should return accreditation_path' do
        routes.stub(:purchase_process_accreditation_path).with(component).
        and_return('purchase_process_accreditation_path')

        expect(subject.accreditation_path(routes)).to eq 'purchase_process_accreditation_path'
      end
    end

    context 'when is not persisted' do
      before { component.stub(:persisted? => false) }

      it 'should return #' do
        expect(subject.accreditation_path(routes)).to eq '#'
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
