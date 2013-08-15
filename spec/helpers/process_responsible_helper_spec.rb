require 'spec_helper'

describe ProcessResponsiblesHelper do
  describe '#link_create_or_edit' do

    context "when process_responsibles is empty" do
      let(:purchase_process) { double(LicitationProcess, id: 1, process_responsibles: []) }

      it 'should return Criar responsável' do
        expect(helper.link_create_or_edit(purchase_process)).to eq 'Criar responsável'
      end
    end

    context "when process_responsibles is not empty" do
      let(:purchase_process) { double(LicitationProcess, id: 1, process_responsibles: [double(ProcessResponsible, id: 1)]) }

      it 'should return Criar responsável' do
        expect(helper.link_create_or_edit(purchase_process)).to eq 'Editar responsável'
      end
    end
  end
end
