require 'unit_helper'
require 'app/business/modality_limit_chooser'

describe ModalityLimitChooser do
  let(:purchase_process) { double(:purchase_process) }
  let(:modality_limit) { double(:modality_limit) }
  let(:modality_limit_repository) { double(:modality_limit_repository, current: modality_limit) }

  describe '#limit' do
    subject do
      described_class.new purchase_process, repository: modality_limit_repository
    end

    context 'when purchase_process is a direct_purchase' do
      before do
        purchase_process.stub(direct_purchase?: true, licitation?: false)
      end

      context 'when type_of_removal is not removal_by_limit' do
        before do
          purchase_process.stub(type_of_removal_removal_by_limit?: false)
        end

        it 'should be nil' do
          expect(subject.limit).to be_nil
        end
      end

      context 'when type_of_removal is removal_by_limit' do
        before do
          purchase_process.stub(type_of_removal_removal_by_limit?: true)
        end

        context 'when object_type is purchase_and_services' do
          before do
            purchase_process.stub(purchase_and_services?: true)
          end

          it 'should return the without_bidding value' do
            modality_limit.should_receive(:without_bidding).and_return 10

            expect(subject.limit).to eq 10
          end
        end

        context 'when object_type is construction_and_engineering_services' do
          before do
            purchase_process.stub(purchase_and_services?: false)
            purchase_process.stub(construction_and_engineering_services?: true)
          end

          it 'should return the work_without_bidding value' do
            modality_limit.should_receive(:work_without_bidding).and_return 100

            expect(subject.limit).to eq 100
          end
        end
      end
    end

    context 'when purchase_process is a licitation' do
      before do
        purchase_process.stub(direct_purchase?: false, licitation?: true)
      end

      context 'when modality is invitation' do
        before do
          purchase_process.stub(invitation?: true)
        end

        context 'when object_type is purchase_and_services' do
          before do
            purchase_process.stub(purchase_and_services?: true)
          end

          it 'should return the invitation_letter value' do
            modality_limit.should_receive(:invitation_letter).and_return 200

            expect(subject.limit).to eq 200
          end
        end

        context 'when object_type is construction_and_engineering_services' do
          before do
            purchase_process.stub(purchase_and_services?: false)
            purchase_process.stub(construction_and_engineering_services?: true)
          end

          it 'should return the work_invitation_letter value' do
            modality_limit.should_receive(:work_invitation_letter).and_return 300

            expect(subject.limit).to eq 300
          end
        end
      end

      context 'when modality is taken_price' do
        before do
          purchase_process.stub(invitation?: false)
          purchase_process.stub(taken_price?: true)
        end

        context 'when object_type is purchase_and_services' do
          before do
            purchase_process.stub(purchase_and_services?: true)
          end

          it 'should return the taken_price value' do
            modality_limit.should_receive(:taken_price).and_return 400

            expect(subject.limit).to eq 400
          end
        end

        context 'when object_type is construction_and_engineering_services' do
          before do
            purchase_process.stub(purchase_and_services?: false)
            purchase_process.stub(construction_and_engineering_services?: true)
          end

          it 'should return the work_taken_price value' do
            modality_limit.should_receive(:work_taken_price).and_return 500

            expect(subject.limit).to eq 500
          end
        end
      end

      context 'when modality is not taken_price neither invitation' do
        before do
          purchase_process.stub(invitation?: false)
          purchase_process.stub(taken_price?: false)
        end

        it 'should be nil' do
          expect(subject.limit).to be_nil
        end
      end
    end
  end

  describe '.limit' do
    it 'should instantiate and call limit' do
      instance = double(:instance)

      described_class.
        should_receive(:new).
        with(purchase_process, repository: modality_limit_repository).
        and_return(instance)

      instance.should_receive(:limit)

      described_class.limit(purchase_process, repository: modality_limit_repository)
    end
  end
end
