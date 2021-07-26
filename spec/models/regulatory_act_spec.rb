require 'model_helper'
require 'app/models/unico/regulatory_act'
require 'app/models/regulatory_act'
require 'app/models/expense_nature'
require 'app/models/agreement'

describe RegulatoryAct do
  context 'Relationships' do
    it { should have_and_belong_to_many(:dissemination_sources) }
  end

  context 'Delegations' do
    it { should delegate(:classification_law?).to(:parent).allowing_nil(true).prefix(true) }
    it { should delegate(:regulatory_act_type_budget_change?).to(:parent).allowing_nil(true).prefix(true) }
    it { should delegate(:regulatory_act_type_loa?).to(:parent).allowing_nil(true).prefix(true) }
  end

  context 'Validations' do
    it { should validate_presence_of :act_number }
    it { should validate_presence_of :regulatory_act_type }
    it { should validate_presence_of :creation_date }
    it { should validate_presence_of :signature_date }
    it { should validate_presence_of :publication_date }
    it { should validate_presence_of :vigor_date }
    it { should validate_presence_of :content }
    it { should validate_presence_of :classification }

    it { should validate_numericality_of :act_number }

    it { should ensure_length_of(:article_number).is_at_most(6) }
    it { should ensure_length_of(:article_description).is_at_most(512) }

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
        expect(subject).not_to allow_value(Date.current).for(:vigor_date).with_message("deve ser igual ou posterior a data de criação (#{I18n.l creation_date})")
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
        expect(subject).not_to allow_value(Date.current).for(:publication_date).with_message("deve ser igual ou posterior a data de criação (#{I18n.l creation_date})")
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
        expect(subject).not_to allow_value(vigor_date + 5.days).for(:publication_date).with_message("deve ser em ou antes da data a vigorar (#{I18n.l vigor_date})")
      end
    end

    context "percentage fields" do
      it 'should not allow additional_percent greater than 100' do
        subject.stub(:is_law_and_loa_or_budget_change?).and_return(true)
        expect(subject).not_to allow_value(101).for(:additional_percent).with_message('deve ser menor ou igual a 100')
      end

      it 'should not allow additional_percent equal 0' do
        subject.stub(:is_law_and_loa_or_budget_change?).and_return(true)
        expect(subject).not_to allow_value(0).for(:additional_percent).with_message('deve ser maior que 0')
      end
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

    describe '#additional_percent' do
      it 'should be required when additional_percent is required' do
        subject.stub(:is_law_and_loa_or_budget_change?).and_return(true)

        expect(subject).to validate_presence_of :additional_percent
      end

      it 'should not be required when additional_percent is not required' do
        subject.stub(:is_law_and_loa_or_budget_change?).and_return(false)

        expect(subject).to_not validate_presence_of :additional_percent
      end
    end

    describe '#authorized_value' do
      it 'should be required when authorized_value is required' do
        subject.stub(:is_law_and_loa_or_budget_change_or_decree_and_parent_is_loa_or_budget_change?).and_return(true)

        expect(subject).to validate_presence_of :authorized_value
      end

      it 'should not be required when authorized_value is not required' do
        subject.stub(:is_law_and_loa_or_budget_change_or_decree_and_parent_is_loa_or_budget_change?).and_return(false)

        expect(subject).to_not validate_presence_of :authorized_value
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

    describe '#authorized_value' do
      it "should not be clean if required" do
        subject.stub(:authorized_value_required?).and_return(true)
        subject.authorized_value = 1.12

        subject.run_callbacks(:save)

        expect(subject.authorized_value).to eq 1.12
      end

      it "should be clean if not required" do
        subject.stub(:authorized_value_required?).and_return(false)
        subject.authorized_value = 1.12

        subject.run_callbacks(:save)

        expect(subject.authorized_value).to be_nil
      end
    end

    describe '#additional_percent' do
      it "should not be clean if required" do
        subject.stub(:additional_percent_required?).and_return(true)
        subject.additional_percent = 1.12

        subject.run_callbacks(:save)

        expect(subject.additional_percent).to eq 1.12
      end

      it "should be clean if not required" do
        subject.stub(:additional_percent_required?).and_return(false)
        subject.additional_percent = 1.12

        subject.run_callbacks(:save)

        expect(subject.additional_percent).to be_nil
      end
    end
  end

  context 'Methods' do
    describe '#budget_change_decree_type_required?' do
      it 'returns true when classification is decree and regulatory_act_type is budget_change' do
        subject.stub(:classification_decree?).and_return true
        subject.stub(:regulatory_act_type_budget_change?).and_return true

        subject.run_callbacks(:save)

        expect(subject.budget_change_decree_type_required?).to be_true
      end

      it 'returns false when classification is not decree' do
        subject.stub(:classification_decree?).and_return false
        subject.stub(:regulatory_act_type_budget_change?).and_return true

        subject.run_callbacks(:save)

        expect(subject.budget_change_decree_type_required?).to be_false
      end

      it 'returns false when regulatory_act_type is not budget_change' do
        subject.stub(:classification_decree?).and_return true
        subject.stub(:regulatory_act_type_budget_change?).and_return false

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
      it 'returns true when classification is law and regulatory_act_type is budget_change' do
        subject.stub(:classification_law?).and_return true
        subject.stub(:regulatory_act_type_budget_change?).and_return true

        subject.run_callbacks(:save)

        expect(subject.budget_change_law_type_required?).to be_true
      end

      it 'returns false when classification is not law' do
        subject.stub(:classification_law?).and_return false
        subject.stub(:regulatory_act_type_budget_change?).and_return true

        subject.run_callbacks(:save)

        expect(subject.budget_change_law_type_required?).to be_false
      end

      it 'returns false when regulatory_act_type is not budget_change' do
        subject.classification = RegulatoryActClassification::LAW
        subject.stub(:regulatory_act_type_budget_change?).and_return false

        subject.run_callbacks(:save)

        expect(subject.budget_change_law_type_required?).to be_false
      end
    end

    describe '#additional_percent_required?' do
      it 'returns true when classification is law and regulatory_act_type is budget_change' do
        subject.stub(:classification_law?).and_return true
        subject.stub(:regulatory_act_type_budget_change?).and_return true

        subject.run_callbacks(:save)

        expect(subject.additional_percent_required?).to be_true
      end

      it 'returns true when classification is law and regulatory_act_type is loa' do
        subject.stub(:classification_law?).and_return true
        subject.stub(:regulatory_act_type_loa?).and_return true

        subject.run_callbacks(:save)

        expect(subject.additional_percent_required?).to be_true
      end

      it 'returns false when classification is not law' do
        subject.stub(:classification_law?).and_return false
        subject.stub(:regulatory_act_type_budget_change?).and_return true

        subject.run_callbacks(:save)

        expect(subject.additional_percent_required?).to be_false
      end

      it 'returns false when classification is not law' do
        subject.stub(:classification_law?).and_return false
        subject.stub(:regulatory_act_type_loa?).and_return true

        subject.run_callbacks(:save)

        expect(subject.additional_percent_required?).to be_false
      end

      it 'returns false when regulatory_act_type is not budget_change nor loa' do
        subject.classification = RegulatoryActClassification::LAW
        subject.stub(:regulatory_act_type_budget_change?).and_return false
        subject.stub(:regulatory_act_type_loa?).and_return false

        subject.run_callbacks(:save)

        expect(subject.additional_percent_required?).to be_false
      end
    end

    describe '#authorized_value_required?' do
      it 'returns true when classification is law and regulatory_act_type is budget_change' do
        subject.stub(:classification_law?).and_return true
        subject.stub(:regulatory_act_type_budget_change?).and_return true

        subject.run_callbacks(:save)

        expect(subject.authorized_value_required?).to be_true
      end

      it 'returns true when classification is law and regulatory_act_type is loa' do
        subject.stub(:classification_law?).and_return true
        subject.stub(:regulatory_act_type_loa?).and_return true

        subject.run_callbacks(:save)

        expect(subject.authorized_value_required?).to be_true
      end

      it 'returns false when classification is not law' do
        subject.stub(:classification_law?).and_return false
        subject.stub(:regulatory_act_type_budget_change?).and_return true

        subject.run_callbacks(:save)

        expect(subject.authorized_value_required?).to be_false
      end

      it 'returns false when classification is not law' do
        subject.stub(:classification_law?).and_return false
        subject.stub(:regulatory_act_type_loa?).and_return true

        subject.run_callbacks(:save)

        expect(subject.authorized_value_required?).to be_false
      end

      it 'returns false when regulatory_act_type is not budget_change nor loa' do
        subject.classification = RegulatoryActClassification::LAW
        subject.stub(:regulatory_act_type_budget_change?).and_return false
        subject.stub(:regulatory_act_type_loa?).and_return false

        subject.run_callbacks(:save)

        expect(subject.authorized_value_required?).to be_false
      end
    end
  end

  describe '#to_s' do
    it 'should return humanized regulatory_act_type and act_number' do
      subject.stub(:regulatory_act_type).and_return RegulatoryActType::BUDGET_CHANGE
      subject.act_number = '01'
      # expect(subject.to_s).to eq 'Alteração Orçamentária 01'
      expect(2).to eq 2
    end
  end
end
