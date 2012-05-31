# encoding: utf-8
require 'model_helper'
require 'app/models/creditor'
require 'app/models/creditor_document'
require 'app/models/creditor_representative'
require 'app/models/document_type'
require 'app/models/creditor_secondary_cnae'
require 'app/models/cnae'

describe Creditor do
  it { should belong_to :person }
  it { should belong_to :occupation_classification }
  it { should belong_to :company_size }
  it { should belong_to :main_cnae }
  it { should have_many :creditor_secondary_cnaes }
  it { should have_many(:cnaes).through(:creditor_secondary_cnaes) }
  it { should have_many(:documents) }
  it { should have_many(:document_types).through(:documents) }
  it { should have_many(:representatives) }
  it { should have_many(:representative_people).through(:representatives) }

  it { should validate_presence_of :person }
  it { should_not validate_presence_of :company_size }
  it { should_not validate_presence_of :main_cnae }
  it { should_not validate_presence_of :contract_start_date }
  it { should_not validate_presence_of :social_identification_number }

  context 'when is company' do
    before do
      subject.stub(:company?).and_return(true)
    end

    it { should validate_presence_of :company_size }
    it { should validate_presence_of :main_cnae }
  end

  context 'when is autonomous' do
    before do
      subject.stub(:autonomous?).and_return(true)
    end

    it { should validate_presence_of :contract_start_date }
    it { should validate_presence_of :social_identification_number }
  end

  context 'when is not autonomous' do
    before do
      subject.stub(:autonomous?).and_return(false)
    end

    it "contract_start_date should be nil" do
      subject.contract_start_date = Date.new(2012, 04, 05)

      subject.run_callbacks(:save)

      subject.contract_start_date.should be nil
    end

    it "social_identification_number should be nil" do
      subject.social_identification_number = 12345

      subject.run_callbacks(:save)

      subject.social_identification_number.should be nil
    end
  end

  it "should return selected_cnaes" do
    subject.stub(:cnae_ids).and_return( [1, 2, 3] )
    subject.main_cnae_id = 4
    subject.selected_cnaes.should == [1, 2, 3, 4]
  end

  context 'uniqueness of document_type_id' do
    let :document_one do
      CreditorDocument.new :document_type_id => 1
    end

    let :document_two do
      CreditorDocument.new :document_type_id => 1
    end

    it 'document should_not be invalid when not duplicated' do
      document_two.document_type_id = 2
      subject.documents = [document_one, document_two]
      subject.should_not be_valid
      subject.errors.messages[:documents].should be_nil
      subject.documents.last.errors.messages[:document_type_id].should be_nil
    end

    it 'document should be invalid when duplicated' do
      subject.documents = [document_one, document_two]
      subject.should_not be_valid
      subject.errors.messages[:documents].should include("não é válido")
      subject.documents.last.errors.messages[:document_type_id].should include("já está em uso")
    end
  end
end
