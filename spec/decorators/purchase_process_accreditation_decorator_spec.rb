# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/purchase_process_accreditation_decorator'

describe PurchaseProcessAccreditationDecorator do
  context "#must_have_creditors" do
    describe 'whith must_have_creditors' do
      it 'should return must_have_creditors' do
        component.stub(:creditors).and_return([double(:creditors, :id => 1)])
        expect(subject.must_have_creditors).to be_nil
      end
    end

    describe 'whithout must_have_creditors' do
      it 'should return "Inclua algum credor primeiro"' do
        I18n.backend.store_translations 'pt-BR', :purchase_process_accreditation => {
          :messages => {
            :must_have_creditors => 'Inclua algum credor primeiro'
          }
        }
        component.stub(:creditors).and_return([])
        expect(subject.must_have_creditors).to eq "Inclua algum credor primeiro"
      end
    end

    describe 'accreditation_path' do
      let(:routes) { double(:routes) }

      it 'should return accreditation_path when persisted' do
        component.stub(:persisted? => true, :component => double(:id => 1))

        routes.stub(:purchase_process_accreditation_path).
        with(component).and_return('purchase_process_accreditation_path')

        expect(subject.accreditation_path(routes)).to eq 'purchase_process_accreditation_path'
      end

      it 'should return # when is not persisted' do
        component.stub(:persisted? => false)
        expect(subject.accreditation_path(routes)).to eq '#'
      end
    end
  end
end
