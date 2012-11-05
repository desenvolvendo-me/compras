# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_commission'
require 'app/models/licitation_commission_responsible'
require 'app/models/licitation_commission_member'
require 'app/models/unico/individual'
require 'app/models/individual'
require 'app/models/judgment_commission_advice'

describe LicitationCommission do
  it { should validate_presence_of :commission_type }
  it { should validate_presence_of :nomination_date }
  it { should validate_presence_of :expiration_date }
  it { should validate_presence_of :regulatory_act }
  it { should validate_duplication_of(:individual_id).on(:licitation_commission_responsibles) }
  it { should validate_duplication_of(:individual_id).on(:licitation_commission_members) }

  it { should belong_to :regulatory_act }

  it { should have_many(:licitation_commission_responsibles).dependent(:destroy).order(:id) }
  it { should have_many(:licitation_commission_members).dependent(:destroy).order(:id) }
  it { should have_many(:judgment_commission_advices).dependent(:restrict) }

  describe "#to_s" do
    subject do
      LicitationCommission.new(:commission_type => CommissionType::PERMANENT,
                               :nomination_date => Date.new(2012, 2, 1),
                               :description => 'COMISSÃO PERMANENTE DE LICITAÇÕES PÚBLICAS')
    end

    it "returns the commission type, nomination date and description" do
      expect(subject.to_s).to eq "COMISSÃO PERMANENTE DE LICITAÇÕES PÚBLICAS - Tipo: Permanente - Data de Nomeação: 01/02/2012"
    end
  end

  context 'validate dates based on nomination_date' do
    before do
      subject.stub(:nomination_date).and_return(Date.new(2012, 12, 20))
    end

    context 'expiration_date' do
      it 'should not allow expiration_date before nomination_date' do
        expect(subject).not_to allow_value(Date.new(2012, 11, 1)).for(:expiration_date).
                                                              with_message('deve ser igual ou posterior a data da nomeação (20/12/2012)')
      end

      it 'should allow expiration_date equals to nomination_date' do
        expect(subject).to allow_value(Date.new(2012, 12, 20)).for(:expiration_date)
      end

      it 'should allow expiration_date after nomination_date' do
        expect(subject).to allow_value(Date.new(2012, 12, 31)).for(:expiration_date)
      end
    end

    context 'exoneration_date' do
      it 'should not allow exoneration_date before nomination_date' do
        expect(subject).not_to allow_value(Date.new(2012, 11, 1)).for(:exoneration_date).
                                                              with_message('deve ser igual ou posterior a data da nomeação (20/12/2012)')
      end

      it 'should allow exoneration_date equals to nomination_date' do
        expect(subject).to allow_value(Date.new(2012, 12, 20)).for(:exoneration_date)
      end

      it 'should allow exoneration_date after nomination_date' do
        expect(subject).to allow_value(Date.new(2012, 12, 31)).for(:exoneration_date)
      end
    end
  end

  context "validates auctioneer and support team if trading commission" do
    before do
      subject.licitation_commission_members.stub(:auctioneer => [],
                                                 :support_team => [])
      subject.stub(:trading? => true)

      subject.valid?
    end

    it "validates presence of auctioneer" do
      expect(subject.errors[:licitation_commission_members]).to include "deve ter ao menos um pregoeiro"
    end

    it "validates presence of support team" do
      expect(subject.errors[:licitation_commission_members]).to include "deve ter ao menos um membro na equipe de apoio"
    end
  end

  it "should delegate publication_date to regulatory_act with prefix" do
    subject.stub(:regulatory_act).and_return stub(:publication_date => Date.new(2012, 2, 28))
    expect(subject.regulatory_act_publication_date).to eq Date.new(2012, 2, 28)
  end

  context 'must have one president' do
    let(:member_1) do
      double('member 1', :individual_id => 1, :president? => false, :marked_for_destruction? => false)
    end

    let(:president_1) do
      double('president 1', :individual_id => 3, :president? => true, :marked_for_destruction? => false)
    end

    let(:president_2) do
      double('president 2', :individual_id => 4, :president? => true, :marked_for_destruction? => false)
    end

    it "must be invalid when there is no president" do
      subject.stub(:licitation_commission_members).and_return([member_1])

      subject.valid?

      expect(subject.errors.messages[:licitation_commission_members]).to include 'deve haver um presidente'
    end

    it "must be invalid when there are two presidents" do
      subject.stub(:licitation_commission_members).and_return([president_1, president_2])

      subject.valid?

      expect(subject.errors.messages[:licitation_commission_members]).to include 'deve haver apenas um presidente'
    end

    it "must be valid when there are one president" do
      subject.stub(:licitation_commission_members).and_return([president_1, member_1])

      subject.valid?

      expect(subject.errors.messages[:licitation_commission_members]).to be_nil
    end
  end

  describe "#expired?" do
    it "returns true if expiration_date < current date" do
      commission = LicitationCommission.new(:expiration_date => Date.new(2012, 2, 1))
      expect(commission.expired?(Date.new(2012, 2, 2))).to be true
    end
  end

  describe "#exonerated?" do
    it "returns true if exoneration date is present" do
      commission = LicitationCommission.new(:exoneration_date => Date.new(2012, 2, 1))
      expect(commission.exonerated?).to be true
    end
  end
end
