require 'spec_helper'

describe LicitationProcess do
  it 'auto increment process by year' do
    licitation_2012 = LicitationProcess.make!(:processo_licitatorio, :year => 2012, :process => nil)
    expect(licitation_2012.process).to eq 1

    licitation_2013 = LicitationProcess.make!(:processo_licitatorio, :year => 2013, :process => nil, )
    expect(licitation_2013.process).to eq 1

    licitation_2013_2 = LicitationProcess.make!(:processo_licitatorio, :year => 2013, :process => nil, :caution_value => 1.99)
    expect(licitation_2013_2.process).to eq 2
  end

  context 'uniqueness validations' do
    before { LicitationProcess.make!(:processo_licitatorio, process_date: Date.current) }

    it { should validate_uniqueness_of(:process).scoped_to(:year) }
  end

  it 'auto increment modality_number by year and modality' do
    licitation_2012 = LicitationProcess.make!(:processo_licitatorio, :year => 2012, :process => nil)
    expect(licitation_2012.modality_number).to eq 1

    licitation_2013 = LicitationProcess.make!(:processo_licitatorio, :year => 2013, :process => nil)
    expect(licitation_2013.modality_number).to eq 1

    licitation_2013_2 = LicitationProcess.make!(:processo_licitatorio, :year => 2013, :process => nil, :caution_value => 1.99)
    expect(licitation_2013_2.modality_number).to eq 2

    licitation_2013_3 = LicitationProcess.make!(:processo_licitatorio, :year => 2013, :process => nil, :modality => Modality::COMPETITION)
    expect(licitation_2013_3.modality_number).to eq 1

    licitation_2013_4 = LicitationProcess.make!(:processo_licitatorio, :year => 2013, :process => nil, :modality => Modality::COMPETITION, :caution_value => 1.99)
    expect(licitation_2013_4.modality_number).to eq 2
  end

  describe "#validate_proposal_envelope_opening_date" do
    let(:publication) { LicitationProcessPublication.make(:publicacao, :publication_date => Date.new(2013, 6, 1)) }

    context "competition modality validation" do
      it "should be 45 calendar days greater than last publication date" do
        licitation = LicitationProcess.make!(:processo_licitatorio_concurso, :publications => [publication])
        licitation.proposal_envelope_opening_date = Date.new(2013, 6, 1) + 44.days

        expect(licitation).to_not be_valid
        expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser em ou depois de #{I18n.l(Date.new(2013, 6, 1) + 45.days)}"

        licitation.proposal_envelope_opening_date = Date.new(2013, 6, 1) + 45.days
        expect(licitation).to be_valid
      end
    end

    context "concurrence modality validation" do
      let(:licitation) do
        LicitationProcess.make!(:processo_licitatorio_concorrencia, :publications => [publication])
      end

      context "integral execution type" do
        it "should be 45 calendar days greater than last publication date when best technique or technical and price" do
          licitation.proposal_envelope_opening_date = Date.new(2013, 6, 1) + 44.days

          licitation.judgment_form.licitation_kind = LicitationKind::BEST_TECHNIQUE
          expect(licitation).to_not be_valid
          expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser em ou depois de #{I18n.l(Date.new(2013, 6, 1) + 45.days)}"

          licitation.judgment_form.licitation_kind = LicitationKind::TECHNICAL_AND_PRICE
          expect(licitation).to_not be_valid
          expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser em ou depois de #{I18n.l(Date.new(2013, 6, 1) + 45.days)}"

          licitation.proposal_envelope_opening_date = Date.new(2013, 6, 1) + 45.days
          expect(licitation).to be_valid
        end
      end

      context "execution type different from integral" do
        it "should be 30 calendar days greater than last publication date" do
          licitation.execution_type = ExecutionType::TASK
          licitation.proposal_envelope_opening_date = Date.new(2013, 6, 1) + 29.days
          licitation.judgment_form.licitation_kind = LicitationKind::BEST_TECHNIQUE

          expect(licitation).to_not be_valid
          expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser em ou depois de #{I18n.l(Date.new(2013, 6, 1) + 30.days)}"

          licitation.judgment_form.licitation_kind = LicitationKind::TECHNICAL_AND_PRICE

          expect(licitation).to_not be_valid
          expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser em ou depois de #{I18n.l(Date.new(2013, 6, 1) + 30.days)}"

          licitation.execution_type = ExecutionType::INTEGRAL
          licitation.judgment_form.licitation_kind = LicitationKind::BEST_AUCTION_OR_OFFER

          expect(licitation).to_not be_valid
          expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser em ou depois de #{I18n.l(Date.new(2013, 6, 1) + 30.days)}"

          licitation.execution_type = ExecutionType::TASK

          licitation.proposal_envelope_opening_date = Date.new(2013, 6, 1) + 30.days
          expect(licitation).to be_valid
        end
      end
    end

    context "taken price modality validation" do
      let(:licitation)  { LicitationProcess.make!(:processo_licitatorio_tomada_preco, :publications => [publication]) }

      context "licitation kind is best technique or technical and price" do
        it "should be 30 calendar days greater than last publication date" do
          licitation.proposal_envelope_opening_date = Date.new(2013, 6, 1) + 29.days
          licitation.judgment_form.licitation_kind = LicitationKind::BEST_TECHNIQUE

          expect(licitation).to_not be_valid
          expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser em ou depois de #{I18n.l(Date.new(2013, 6, 1) + 30.days)}"

          licitation.judgment_form.licitation_kind = LicitationKind::TECHNICAL_AND_PRICE

          expect(licitation).to_not be_valid
          expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser em ou depois de #{I18n.l(Date.new(2013, 6, 1) + 30.days)}"

          licitation.proposal_envelope_opening_date = Date.new(2013, 6, 1) + 30.days
          expect(licitation).to be_valid
        end
      end

      context "execution type different from integral" do
        it "should be 15 calendar days greater than last publication date" do
          licitation.judgment_form.licitation_kind = LicitationKind::BEST_AUCTION_OR_OFFER
          licitation.save
          licitation.proposal_envelope_opening_date = Date.new(2013, 6, 1) + 14.days

          expect(licitation).to_not be_valid
          expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser em ou depois de #{I18n.l(Date.new(2013, 6, 1) + 15.days)}"

          licitation.proposal_envelope_opening_date = Date.new(2013, 6, 1) + 15.days
          expect(licitation).to be_valid
        end
      end
    end

    context "auction modality validation" do
      it "should be 15 calendar days greater than last publication date" do
        licitation = LicitationProcess.make!(:processo_licitatorio_leilao, :publications => [publication])
        licitation.proposal_envelope_opening_date = Date.new(2013, 6, 1) + 14.days

        expect(licitation).to_not be_valid
        expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser em ou depois de #{I18n.l(Date.new(2013, 6, 1) + 15.days)}"

        licitation.proposal_envelope_opening_date = Date.new(2013, 6, 1) + 15.days
        expect(licitation).to be_valid
      end
    end

    context "trading modality validation" do
      it "should be 8 working days greater than last publication date" do
        licitation = LicitationProcess.make!(:processo_licitatorio, :publications => [publication],
                                             :modality => Modality::TRADING, :execution_type => ExecutionType::INTEGRAL)
        licitation.proposal_envelope_opening_date = Date.new(2013, 6, 1) + 5.days

        expect(licitation).to_not be_valid
        expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser em ou depois de 12/06/2013"

        licitation.proposal_envelope_opening_date = Date.new(2013, 6, 1) + 15.days
        expect(licitation).to be_valid
      end
    end

    context "invitation modality validation" do
      it "should be 5 working days greater than last publication date" do
        licitation = LicitationProcess.make!(:processo_licitatorio, :publications => [publication],
                                             :modality => Modality::INVITATION, :execution_type => ExecutionType::INTEGRAL)
        licitation.proposal_envelope_opening_date = Date.new(2013, 6, 1) + 4.days

        expect(licitation).to_not be_valid
        expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser em ou depois de 07/06/2013"

        licitation.proposal_envelope_opening_date = Date.new(2013, 6, 1) + 10.days
        expect(licitation).to be_valid
      end
    end
  end

  describe "no item duplication validation" do
    it 'should validate item duplication for same creditor' do
      item = PurchaseProcessItem.make(:item, creditor: Creditor.make!(:wenderson_sa))

      direct_purchase = LicitationProcess.make(:compra_direta,
        type_of_removal: TypeOfRemoval::DISPENSATION_JUSTIFIED_ACCREDITATION,
        items: [item, item])

      expect(direct_purchase).to_not be_valid

      expect(direct_purchase.errors[:items]).to include "O material para o fornecedor já está em uso"
    end
  end

  describe '.by_type_of_purchase' do
    it 'should return all licitation_process by type_of_purchase' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)
      direct_purchase = LicitationProcess.make!(:compra_direta)

      expect(LicitationProcess.by_type_of_purchase(PurchaseProcessTypeOfPurchase::LICITATION)).to include(licitation_process)
    end
  end

  describe 'material class limit validation' do
    before do
      ModalityLimit.create!(
        without_bidding: 8000.0,
        invitation_letter: 80000.0,
        taken_price: 650000.0,
        public_competition: 99999999.99,
        work_without_bidding: 15000.0,
        work_invitation_letter: 150000.0,
        work_taken_price: 1500000.0,
        work_public_competition: 9999999.99)
    end

    context 'when is a direct_purchase' do
      context 'when is removal_by_limit' do
        context 'when object_type is purchase_and_services' do
          it 'should get an error' do
            item1 = PurchaseProcessItem.make(:item_arame,
              quantity: 1000, unit_price: 7.0, creditor: Creditor.make!(:sobrinho))

            item2 = PurchaseProcessItem.make(:item_arame_farpado,
              quantity: 1000, unit_price: 1.2, creditor: Creditor.make!(:sobrinho))

            purchase_process = LicitationProcess.make(:compra_direta,
              type_of_removal: TypeOfRemoval::REMOVAL_BY_LIMIT,
              object_type: PurchaseProcessObjectType::PURCHASE_AND_SERVICES,
              items: [item1, item2])

            purchase_process.valid?

            expect(purchase_process.errors[:base]).to include('A classe 02.44.65.430.000 - Arames está ultrapassando o limite do tipo de afastamento Dispensa por limite (R$ 8.000,00)')
          end
        end

        context 'when is construction_and_engineering_services' do
          it 'should get an error' do
            item1 = PurchaseProcessItem.make(:item_arame,
              quantity: 1000, unit_price: 10.0, creditor: Creditor.make!(:sobrinho))

            item2 = PurchaseProcessItem.make(:item_arame_farpado,
              quantity: 1000, unit_price: 5.2, creditor: Creditor.make!(:sobrinho))

            purchase_process = LicitationProcess.make(:compra_direta,
              type_of_removal: TypeOfRemoval::REMOVAL_BY_LIMIT,
              object_type: PurchaseProcessObjectType::CONSTRUCTION_AND_ENGINEERING_SERVICES,
              items: [item1, item2])

            purchase_process.valid?

            expect(purchase_process.errors[:base]).to include('A classe 02.44.65.430.000 - Arames está ultrapassando o limite do tipo de afastamento Dispensa por limite (R$ 15.000,00)')
          end
        end

        context 'when is not purchase_and_services neither construction_and_engineering_services' do
          it 'should not get an error' do
            item1 = PurchaseProcessItem.make(:item_arame,
              quantity: 1000, unit_price: 100.0, creditor: Creditor.make!(:sobrinho))

            item2 = PurchaseProcessItem.make(:item_arame_farpado,
              quantity: 1000, unit_price: 10.2, creditor: Creditor.make!(:sobrinho))

            purchase_process = LicitationProcess.make(:compra_direta,
              type_of_removal: TypeOfRemoval::REMOVAL_BY_LIMIT,
              object_type: PurchaseProcessObjectType::CONCESSIONS,
              items: [item1, item2])

            purchase_process.valid?

            expect(purchase_process.errors[:base]).to be_empty
          end
        end
      end

      context 'when is not removal_by_limit' do
        it 'should not get an error' do
          item1 = PurchaseProcessItem.make(:item_arame,
            quantity: 1000, unit_price: 100.0, creditor: Creditor.make!(:sobrinho))

          item2 = PurchaseProcessItem.make(:item_arame_farpado,
            quantity: 1000, unit_price: 10.2, creditor: Creditor.make!(:sobrinho))

          purchase_process = LicitationProcess.make(:compra_direta,
            type_of_removal: TypeOfRemoval::REMOVAL_JUSTIFIED,
            object_type: PurchaseProcessObjectType::CONSTRUCTION_AND_ENGINEERING_SERVICES,
            items: [item1, item2])

          purchase_process.valid?

          expect(purchase_process.errors[:base]).to be_empty
        end
      end
    end

    context 'when is a licitation' do
      context 'when is an invitation' do
        context 'when is purchase_and_services' do
          it 'should get an error' do
            item1 = PurchaseProcessItem.make(:item_arame,
              quantity: 10000, unit_price: 7.0)

            item2 = PurchaseProcessItem.make(:item_arame_farpado,
              quantity: 10000, unit_price: 1.2)

            purchase_process = LicitationProcess.make(:processo_licitatorio_computador,
              modality: Modality::INVITATION,
              object_type: PurchaseProcessObjectType::PURCHASE_AND_SERVICES,
              items: [item1, item2])

            purchase_process.valid?

            expect(purchase_process.errors[:base]).to include('A classe 02.44.65.430.000 - Arames está ultrapassando o limite da modalidade Convite (R$ 80.000,00)')
          end
        end

        context 'when is construction_and_engineering_services' do
          it 'should get an error' do
            item1 = PurchaseProcessItem.make(:item_arame,
              quantity: 10000, unit_price: 10.0)

            item2 = PurchaseProcessItem.make(:item_arame_farpado,
              quantity: 10000, unit_price: 5.2)

            purchase_process = LicitationProcess.make(:processo_licitatorio_computador,
              modality: Modality::INVITATION,
              object_type: PurchaseProcessObjectType::CONSTRUCTION_AND_ENGINEERING_SERVICES,
              items: [item1, item2])

            purchase_process.valid?

            expect(purchase_process.errors[:base]).to include('A classe 02.44.65.430.000 - Arames está ultrapassando o limite da modalidade Convite (R$ 150.000,00)')
          end
        end

        context 'when is not construction_and_engineering_services neither purchase_and_services' do
          it 'should not get an error' do
            item1 = PurchaseProcessItem.make(:item_arame,
              quantity: 10000, unit_price: 10.0)

            item2 = PurchaseProcessItem.make(:item_arame_farpado,
              quantity: 10000, unit_price: 5.2)

            purchase_process = LicitationProcess.make(:processo_licitatorio_computador,
              modality: Modality::INVITATION,
              object_type: PurchaseProcessObjectType::DISPOSALS_OF_ASSETS,
              items: [item1, item2])

            purchase_process.valid?

            expect(purchase_process.errors[:base]).to be_empty
          end
        end
      end

      context 'when is an taken_price' do
        context 'when is purchase_and_services' do
          it 'should get an error' do
            item1 = PurchaseProcessItem.make(:item_arame,
              quantity: 10000, unit_price: 60.0)

            item2 = PurchaseProcessItem.make(:item_arame_farpado,
              quantity: 10000, unit_price: 5.2)

            purchase_process = LicitationProcess.make(:processo_licitatorio_computador,
              modality: Modality::TAKEN_PRICE,
              object_type: PurchaseProcessObjectType::PURCHASE_AND_SERVICES,
              items: [item1, item2])

            purchase_process.valid?

            expect(purchase_process.errors[:base]).to include('A classe 02.44.65.430.000 - Arames está ultrapassando o limite da modalidade Tomada de Preço (R$ 650.000,00)')
          end
        end

        context 'when is construction_and_engineering_services' do
          it 'should get an error' do
            item1 = PurchaseProcessItem.make(:item_arame,
              quantity: 100000, unit_price: 10.0)

            item2 = PurchaseProcessItem.make(:item_arame_farpado,
              quantity: 100000, unit_price: 5.1)

            purchase_process = LicitationProcess.make(:processo_licitatorio_computador,
              modality: Modality::TAKEN_PRICE,
              object_type: PurchaseProcessObjectType::CONSTRUCTION_AND_ENGINEERING_SERVICES,
              items: [item1, item2])

            purchase_process.valid?

            expect(purchase_process.errors[:base]).to include('A classe 02.44.65.430.000 - Arames está ultrapassando o limite da modalidade Tomada de Preço (R$ 1.500.000,00)')
          end
        end

        context 'when is not construction_and_engineering_services neither purchase_and_services' do
          it 'should not get an error' do
            item1 = PurchaseProcessItem.make(:item_arame,
              quantity: 100000, unit_price: 100.0)

            item2 = PurchaseProcessItem.make(:item_arame_farpado,
              quantity: 100000, unit_price: 50.2)

            purchase_process = LicitationProcess.make(:processo_licitatorio_computador,
              modality: Modality::TAKEN_PRICE,
              object_type: PurchaseProcessObjectType::DISPOSALS_OF_ASSETS,
              items: [item1, item2])

            purchase_process.valid?

            expect(purchase_process.errors[:base]).to be_empty
          end
        end
      end

      context 'when is not an taken_price neither invitation' do
        it 'should not get an error' do
          item1 = PurchaseProcessItem.make(:item_arame,
            quantity: 100000, unit_price: 100.0)

          item2 = PurchaseProcessItem.make(:item_arame_farpado,
            quantity: 100000, unit_price: 50.2)

          purchase_process = LicitationProcess.make(:processo_licitatorio_computador,
            modality: Modality::TRADING,
            object_type: PurchaseProcessObjectType::PURCHASE_AND_SERVICES,
            items: [item1, item2])

          purchase_process.valid?

          expect(purchase_process.errors[:base]).to be_empty
        end
      end
    end
  end
end
