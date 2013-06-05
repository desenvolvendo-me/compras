# encoding: utf-8
require 'model_helper'
require 'app/models/regulatory_act'
require 'app/models/expense_nature'
require 'app/models/budget_structure_configuration'
require 'app/models/budget_structure_responsible'
require 'app/models/agreement'

describe RegulatoryAct do
  context 'Relationships' do
    it { should belong_to :regulatory_act_type }
    it { should belong_to :parent }

    it { should have_many(:expense_natures).dependent(:restrict) }
    it { should have_many(:budget_structure_configurations).dependent(:restrict) }
    it { should have_many(:budget_structure_responsibles).dependent(:restrict) }
    it { should have_many(:children).dependent(:restrict) }

    it { should have_and_belong_to_many :dissemination_sources}
  end

  context 'Delegations' do
    it { should delegate(:classification_law?).to(:parent).allowing_nil(true).prefix(true) }
    it { should delegate(:kind).to(:regulatory_act_type).allowing_nil(true).prefix(true) }
  end

  context 'Validations' do
    it { should validate_presence_of :act_number }
    it { should validate_presence_of :regulatory_act_type }
    it { should validate_presence_of :creation_date }
    it { should validate_presence_of :signature_date }
    it { should validate_presence_of :publication_date }
    it { should validate_presence_of :vigor_date }
    it { should validate_presence_of :content }

    it { should validate_numericality_of :budget_law_percent }
    it { should validate_numericality_of :revenue_antecipation_percent }
    it { should validate_numericality_of :act_number }

    it 'should have zero as default value to budget_law_percent' do
      expect(subject.budget_law_percent).to eq 0.0
    end

    it 'should have zero as default value to revenue_antecipation_percent' do
      expect(subject.revenue_antecipation_percent).to eq 0.0
    end

    it 'should have zero as default value to authorized_debt_value' do
      expect(subject.authorized_debt_value).to eq 0.0
    end

    context 'validate vigor_date related with creation_date' do
      let :creation_date do
        Date.current + 10.days
      end

      before do
        subject.stub(:creation_date).and_return(creation_date)
      end

      it 'should allow vigor_date date after creation_date' do
        expect(subject).to allow_value(Date.current + 15.days).for(:vigor_date)
      end

      it 'should allow vigor_date date equals to creation_date' do
        expect(subject).to allow_value(creation_date).for(:vigor_date)
      end

      it 'should not allow vigor_date date before creation_date' do
        expect(subject).not_to allow_value(Date.current).for(:vigor_date).
                                                     with_message("deve ser igual ou posterior a data de criação (#{I18n.l creation_date})")
      end
    end

    context 'validate publication_date related with creation_date' do
      let :creation_date do
        Date.current + 10.days
      end

      before do
        subject.stub(:vigor_date).and_return(creation_date + 20.days)
        subject.stub(:creation_date).and_return(creation_date)
      end

      it 'should allow publication_date date after creation_date' do
        expect(subject).to allow_value(Date.current + 15.days).for(:publication_date)
      end

      it 'should allow publication_date date equals to creation_date' do
        expect(subject).to allow_value(creation_date).for(:publication_date)
      end

      it 'should not allow publication_date date before creation_date' do
        expect(subject).not_to allow_value(Date.current).for(:publication_date).
                                                     with_message("deve ser igual ou posterior a data de criação (#{I18n.l creation_date})")
      end
    end

    context 'validate publication_date related with vigor_date' do
      let :vigor_date do
        Date.current + 10.days
      end

      before do
        subject.stub(:creation_date).and_return(Date.current)
        subject.stub(:vigor_date).and_return(vigor_date)
      end

      it 'should allow publication_date before vigor_date' do
        expect(subject).to allow_value(vigor_date - 5.days).for(:publication_date)
      end

      it 'should allow publication_date equals to vigor_date' do
        expect(subject).to allow_value(vigor_date).for(:publication_date)
      end

      it 'should not allow publication_date after vigor_date' do
        expect(subject).not_to allow_value(vigor_date + 5.days).for(:publication_date).
                                                            with_message("deve ser em ou antes da data a vigorar (#{I18n.l vigor_date})")
      end
    end

    it 'should not allow budget_law_percent greater than 100' do
      expect(subject).not_to allow_value(101).for(:budget_law_percent).
                                             with_message('deve ser menor ou igual a 100')
    end

    it 'should not allow revenue_antecipation_percent greater than 100' do
      expect(subject).not_to allow_value(101).for(:revenue_antecipation_percent).
                                             with_message('deve ser menor ou igual a 100')
    end

    describe '#budget_change_decree_type' do
      it 'should be required when budget_change_decree_type is required' do
        subject.stub(:budget_change_decree_type_required?).and_return(true)

        expect(subject).to validate_presence_of :budget_change_decree_type
      end

      it 'should not be required when budget_change_decree_type is not required' do
        subject.stub(:budget_change_decree_type_required?).and_return(false)

        expect(subject).to_not validate_presence_of :budget_change_decree_type
      end
    end

    describe '#budget_change_law_type' do
      it 'should be required when budget_change_law_type is required' do
        subject.stub(:budget_change_law_type_required?).and_return(true)

        expect(subject).to validate_presence_of :budget_change_law_type
      end

      it 'should not be required when budget_change_law_type is not required' do
        subject.stub(:budget_change_law_type_required?).and_return(false)

        expect(subject).to_not validate_presence_of :budget_change_law_type
      end
    end

    describe '#parent' do
      it 'should be required when classification is decree' do
        subject.stub(:classification).and_return(RegulatoryActClassification::DECREE)

        expect(subject).to validate_presence_of :parent
      end

      it 'should not be required when classification is not decree' do
        subject.stub(:classification).and_return(RegulatoryActClassification::LAW)

        expect(subject).to_not validate_presence_of :parent
      end

      it 'should have law as classification, when child classification is decree' do
        subject.stub(:classification).and_return(RegulatoryActClassification::DECREE)
        subject.stub(:parent_classification).and_return(RegulatoryActClassification::DECREE)

        subject.valid?

        expect(subject.errors[:parent]).to include 'A classificação do Ato principal deve ser Lei, quando a classificação do ato secundário for Decreto'
      end
    end
  end

  context 'Callbacks' do
    describe '#budget_change_decree_type' do
      it "should not be clean if required" do
        subject.stub(:budget_change_decree_type_required?).and_return(true)
        subject.stub(:budget_change_decree_type).and_return(BudgetChangeDecreeType::EXTRAORDINARY_CREDIT_DECREE)

        subject.run_callbacks(:save)

        expect(subject.budget_change_decree_type).to eq BudgetChangeDecreeType::EXTRAORDINARY_CREDIT_DECREE
      end

      it 'should be clean if not required' do
        subject.stub(:budget_change_decree_type_required?).and_return(false)
        subject.budget_change_decree_type = BudgetChangeDecreeType::EXTRAORDINARY_CREDIT_DECREE

        subject.run_callbacks(:save)

        expect(subject.budget_change_decree_type).to be_blank
      end
    end

    describe '#origin' do
      it "should not be clean if updateable" do
        subject.stub(:origin_updateable?).and_return(true)
        subject.origin = Origin::FINANCIAL_SURPLUS

        subject.run_callbacks(:save)

        expect(subject.origin).to eq Origin::FINANCIAL_SURPLUS
      end

      it "should be clean if not updateable" do
        subject.stub(:origin_updateable?).and_return(false)
        subject.origin = Origin::FINANCIAL_SURPLUS

        subject.run_callbacks(:save)

        expect(subject.origin).to be_blank
      end
    end

    describe '#budget_change_law_type' do
      it "should not be clean if required" do
        subject.stub(:budget_change_law_type_required?).and_return(true)
        subject.stub(:budget_change_law_type).and_return(BudgetChangeLawType::SPECIAL_CREDIT_AUTHORIZATION_LAW)

        subject.run_callbacks(:save)

        expect(subject.budget_change_law_type).to eq BudgetChangeLawType::SPECIAL_CREDIT_AUTHORIZATION_LAW
      end

      it 'should be clean if not required' do
        subject.stub(:budget_change_law_type_required?).and_return(false)
        subject.budget_change_law_type = BudgetChangeLawType::SPECIAL_CREDIT_AUTHORIZATION_LAW

        subject.run_callbacks(:save)

        expect(subject.budget_change_law_type).to be_blank
      end
    end
  end

  context 'Methods' do
    describe '#budget_change_decree_type_required?' do
      it 'returns true when classification is decree and regulatory_act_type is "Alteração Orçamentária"' do
        subject.classification = RegulatoryActClassification::DECREE
        subject.stub(:regulatory_act_type).and_return('Alteração Orçamentária')

        subject.run_callbacks(:save)

        expect(subject.budget_change_decree_type_required?).to be_true
      end

      it 'returns false when classification is not decree' do
        subject.classification = RegulatoryActClassification::LAW
        subject.stub(:regulatory_act_type).and_return('Alteração Orçamentária')

        subject.run_callbacks(:save)

        expect(subject.budget_change_decree_type_required?).to be_false
      end

      it 'returns false when regulatory_act_type is not "Alteração Orçamentária"' do
        subject.classification = RegulatoryActClassification::DECREE
        subject.stub(:regulatory_act_type).and_return('PPA')

        subject.run_callbacks(:save)

        expect(subject.budget_change_decree_type_required?).to be_false
      end
    end

    describe 'origin_updateable?' do
      it 'returns true if budget_change_decree_type is extra_credit_decree' do
        subject.budget_change_decree_type = BudgetChangeDecreeType::EXTRA_CREDIT_DECREE
        expect(subject.origin_updateable?).to be_true
      end

      it 'returns true if budget_change_decree_type is special_credit_decree' do
        subject.budget_change_decree_type = BudgetChangeDecreeType::SPECIAL_CREDIT_DECREE
        expect(subject.origin_updateable?).to be_true
      end

      it 'returns false if budget_change_decree_type is other' do
        subject.budget_change_decree_type = BudgetChangeDecreeType::EXTRAORDINARY_CREDIT_DECREE
        expect(subject.origin_updateable?).to be_false
      end
    end

    describe '#budget_change_law_type_required?' do
      it 'returns true when classification is law and regulatory_act_type is "Alteração Orçamentária"' do
        subject.classification = RegulatoryActClassification::LAW
        subject.stub(:regulatory_act_type).and_return('Alteração Orçamentária')

        subject.run_callbacks(:save)

        expect(subject.budget_change_law_type_required?).to be_true
      end

      it 'returns false when classification is not law' do
        subject.classification = RegulatoryActClassification::DECREE
        subject.stub(:regulatory_act_type).and_return('Alteração Orçamentária')

        subject.run_callbacks(:save)

        expect(subject.budget_change_law_type_required?).to be_false
      end

      it 'returns false when regulatory_act_type is not "Alteração Orçamentária"' do
        subject.classification = RegulatoryActClassification::LAW
        subject.stub(:regulatory_act_type).and_return('PPA')

        subject.run_callbacks(:save)

        expect(subject.budget_change_law_type_required?).to be_false
      end
    end
  end

  describe '#to_s' do
    it 'should return act_number' do
      subject.stub(:regulatory_act_type).and_return('Lei')
      subject.act_number = '01'
      expect(subject.to_s).to eq 'Lei 01'
    end
  end
end
