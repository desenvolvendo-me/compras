require 'model_helper'
require 'app/models/process_responsible'

describe ProcessResponsible do
  it { should belong_to :stage_process }
  it { should belong_to :licitation_process }
  it { should belong_to :employee }

  it { should have_many(:judgment_commission_advices).through(:licitation_process) }
  it { should have_many(:licitation_commission_members).through(:judgment_commission_advices) }

  it { should have_one(:street).through(:employee) }
  it { should have_one(:neighborhood).through(:employee) }

  it { should validate_presence_of :stage_process }
  it { should validate_presence_of :licitation_process }

  it { should delegate(:year).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:process).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:name).to(:street).allowing_nil(true).prefix(true) }
  it { should delegate(:name).to(:neighborhood).allowing_nil(true).prefix(true) }
  it { should delegate(:cpf).to(:employee).allowing_nil(true) }
  it { should delegate(:name).to(:employee).allowing_nil(true) }
  it { should delegate(:phone).to(:employee).allowing_nil(true) }
  it { should delegate(:email).to(:employee).allowing_nil(true) }
  it { should delegate(:zip_code).to(:employee).allowing_nil(true) }
  it { should delegate(:city).to(:employee).allowing_nil(true) }
  it { should delegate(:state).to(:employee).allowing_nil(true) }
  it { should delegate(:acronym).to(:state).allowing_nil(true).prefix(true) }
  it { should delegate(:tce_mg_code).to(:city).allowing_nil(true).prefix(true) }
  it { should delegate(:description).to(:stage_process).allowing_nil(true).prefix(true) }

  describe '#destroyable?' do
    context 'when imported' do
      before { subject.imported = true }

      it 'returns false' do
        expect(subject.destroyable?).to be_false
      end
    end

    context 'when not imported' do
      before { subject.imported = false }

      it 'returns true' do
        expect(subject.destroyable?).to be_true
      end
    end
  end

  describe '#not_imported?' do
    it 'return true when not imported' do
      subject.imported = false
      expect(subject.not_imported?).to be_true
    end
  end

  describe '#imported_and_changing_stage_process?' do
    before do
      subject.imported = true
      subject.stage_process_id = 1
      subject.stub(:stage_process_id_was).and_return 3
    end

    it 'returns true when imported and stage_process is changing' do
      expect(subject.send(:imported_and_changing_stage_process?)).to be_true
    end
  end

  describe '#cant_change_stage_process' do
    before do
      subject.stub(:imported_and_changing_stage_process?).and_return true
    end

    it 'validates the stage process when it cannot be changed' do
      subject.send :cant_change_stage_process
      expect(subject.errors[:stage_process]).to include 'não pode ser modificado quando importado automaticamente'
    end
  end
end
