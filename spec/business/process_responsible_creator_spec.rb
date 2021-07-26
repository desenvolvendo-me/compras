require 'unit_helper'
require 'app/business/process_responsible_creator'

describe ProcessResponsibleCreator do
  let(:stage_process_one) { double('StageProcess', id: 1, type_of_purchase: 'licitation') }
  let(:stage_process_two) { double('StageProcess', id: 2, type_of_purchase: 'licitation') }
  let(:stage_process_three) { double('StageProcess', id: 3, type_of_purchase: 'licitation') }
  let(:stage_processes) { [stage_process_one, stage_process_two, stage_process_three] }
  let(:process_responsibles) { [] }
  let(:purchase_process) { double('LicitationProcess', id: 1, type_of_purchase: 'licitation', process_responsibles: process_responsibles) }
  let(:repository) { double(:repository) }

  subject do
    described_class.new(purchase_process, repository)
  end

  describe '#create_responsible_process' do
    context 'when type_of_purchase is nil' do
      before do
        purchase_process.stub(type_of_purchase: nil)
      end

      it "should do nothing" do
        repository.should_not_receive(:send)

        expect(subject.create_responsible_process!).to be_nil
      end
    end

    context 'when type_of_purchase is not nil' do
      before do
        purchase_process.stub(type_of_purchase: 'licitation')
      end

      context 'when process_responsibles is empty' do
        it 'should build process responsibles' do
          repository.should_receive(:send).with('licitation').and_return stage_processes
          process_responsibles.should_receive(:build).with(stage_process_id: 1, imported: true)
          process_responsibles.should_receive(:build).with(stage_process_id: 2, imported: true)
          process_responsibles.should_receive(:build).with(stage_process_id: 3, imported: true)

          subject.create_responsible_process!
        end
      end

      context 'when process_responsibles is not empty' do
        before do
          purchase_process.stub(process_responsibles: [stage_process_two])
        end

        it 'should not build process responsibles' do
          repository.should_not_receive(:send)

          subject.create_responsible_process!
        end
      end
    end
  end

  describe '.create!' do
    let(:instance) { double(:instance) }

    it 'should instantiate and call create_responsible_process' do
      described_class.should_receive(:new).with(purchase_process, repository).and_return instance
      instance.should_receive(:create_responsible_process!)

      described_class.create!(purchase_process, repository)
    end
  end
end
