# encoding: utf-8
require 'model_helper'
require 'app/models/revenue_nature'
require 'app/models/revenue_accounting'

describe RevenueNature do
  it 'should return revenue_nature and specification as to_s' do
    subject.specification = 'Receitas correntes'
    subject.stub(:revenue_nature).and_return('1.0.0.0')

    subject.to_s.should eq '1.0.0.0 - Receitas correntes'
  end

  it { should validate_presence_of :regulatory_act }
  it { should validate_presence_of :classification }
  it { should validate_presence_of :revenue_category }
  it { should validate_presence_of :specification }
  it { should validate_presence_of :kind }
  it { should validate_presence_of :docket }
  it { should validate_presence_of :entity }
  it { should validate_presence_of :year }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('2a12').for(:year) }

  it { should allow_value('12.34').for(:classification) }
  it { should_not allow_value('1a34').for(:classification) }
  it { should_not allow_value('1a.34').for(:classification) }

  it { should belong_to :entity }
  it { should belong_to :regulatory_act }
  it { should belong_to :revenue_category }
  it { should belong_to :revenue_subcategory }
  it { should belong_to :revenue_source }
  it { should belong_to :revenue_rubric }

  it { should have_many(:revenue_accountings).dependent(:restrict) }

  context 'cascate validate' do
    context 'subcategory should have related with category' do
      before do
        subject.stub(:revenue_subcategory).and_return(double('Subcategory', :revenue_category_id => 1))
      end

      it 'with invalid subcategory' do
        subject.stub(:revenue_category_id).and_return(2)
        subject.valid?
        subject.errors[:revenue_subcategory].should include('subcategoria da receita deve estar relacionada com categoria da receita')
      end

      it 'with valid subcategory' do
        subject.stub(:revenue_category_id).and_return(1)
        subject.valid?
        subject.errors[:revenue_subcategory].should be_blank
      end
    end

    context 'source should have related with subcategory' do
      before do
        subject.stub(:revenue_source).and_return(double('Source', :revenue_subcategory_id => 1))
      end

      it 'with invalid source' do
        subject.stub(:revenue_subcategory_id).and_return(2)
        subject.valid?
        subject.errors[:revenue_source].should include('fonte da receita deve estar relacionada com subcategoria da receita')
      end

      it 'with valid source' do
        subject.stub(:revenue_source_id).and_return(1)
        subject.valid?
        subject.errors[:revenue_source].should_not include('fonte da receita deve estar relacionada com subcategoria da receita')
      end
    end

    context 'rubric should have related with source' do
      before do
        subject.stub(:revenue_rubric).and_return(double('Rubric', :revenue_source_id => 1))
      end

      it 'with invalid rubric' do
        subject.stub(:revenue_source_id).and_return(2)
        subject.valid?
        subject.errors[:revenue_rubric].should include('rúbrica da receita deve estar relacionada com fonte da receita')
      end

      it 'with valid rubric' do
        subject.stub(:revenue_source_id).and_return(1)
        subject.valid?
        subject.errors[:revenue_rubric].should_not include('rúbrica da receita deve estar relacionada com fonte da receita')
      end
    end
  end
end
