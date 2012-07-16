# encoding: utf-8
require 'model_helper'
require 'app/models/unico/person'
require 'app/models/person'
require 'app/models/employee'
require 'app/models/economic_registration'
require 'app/models/licitation_process_impugnment'
require 'app/models/licitation_process_appeal'
require 'app/models/unico/partner'
require 'app/models/partner'
require 'app/models/creditor'
require 'app/models/licitation_process_bidder'
require 'app/models/accredited_representative'

describe Person do
  it "return name when call to_s" do
    subject.name = "Wenderson"
    subject.to_s.should eq subject.name
  end

  context "#correspondence_address?" do
    it "should return true if has correspondence address" do
      subject.stub_chain(:correspondence_address, :present?).and_return(true)
      subject.correspondence_address?.should be_true
    end
  end

  describe "#company?" do
    it "should be a company" do
      subject.stub(:personable).and_return(double(:cnpj => '12345'))
      subject.company?.should be_true
    end

    it "should not be a company" do
      subject.stub(:personable_type).and_return("Individual")
      subject.company?.should be_false
    end
  end

  describe '#individual' do
    it 'should be individual' do
      subject.stub(:personable).and_return(double(:cpf => '12345'))
      subject.should be_individual
    end

    it 'should not be individual' do
      subject.stub(:personable_type).and_return 'Company'
      subject.should_not be_individual
    end
  end

  it { should have_one :employee }

  it { should have_many(:economic_registrations).dependent(:restrict) }
  it { should have_many(:licitation_process_impugnments).dependent(:restrict) }
  it { should have_many(:licitation_process_appeals).dependent(:restrict) }
  it { should have_many :partners }
  it { should have_many(:creditors).dependent(:restrict) }
  it { should have_many(:licitation_process_bidders).through(:accredited_representatives) }
  it { should have_many(:accredited_representatives).dependent(:restrict) }

  it 'should be special when personable_type is SpecialEntry' do
    subject.stub(:personable_type).and_return('SpecialEntry')

    subject.should be_special
  end

  it 'should not be special if personable_tye is not SpecialEntry' do
    subject.stub(:personable_type).and_return('Company')

    subject.should_not be_special
  end

  it "should return an empty string on identity document when personable doesn't respond_to both cpf and cnpj" do
    subject.identity_document.should eq ''
  end

  it "should return cpf on identity document when personable respond_to cpf" do
    subject.stub(:cpf).and_return('059.894.946-10')
    subject.identity_document.should eq '059.894.946-10'
  end

  it "should return cnpj on identity_document when personable respond_to cnpj" do
    subject.stub(:cnpj).and_return('76.238.594/0001-35')
    subject.identity_document.should eq '76.238.594/0001-35'
  end

  context 'company_size' do
    let :company_size do
      double('CompanySize')
    end

    it 'should not return company_size if is not company' do
      subject.stub(:company?).and_return false
      subject.company_size.should be_nil
    end

    it 'should return company_size if is company' do
      subject.stub(:company_size).and_return company_size
      subject.stub(:company?).and_return false
      subject.company_size.should eq company_size
    end
  end

  context 'choose_simple' do
    it 'should not return choose_simple if is not company' do
      subject.stub(:company?).and_return false
      subject.choose_simple.should be_nil
    end

    it 'should return choose_simple if is company' do
      subject.stub(:choose_simple).and_return true
      subject.stub(:company?).and_return false
      subject.company_size.should be_false
    end
  end

  context 'legal_nature' do
    let :legal_nature do
      double('LegalNature')
    end

    it 'should not return legal_nature if is not company' do
      subject.stub(:company?).and_return false
      subject.legal_nature.should be_nil
    end

    it 'should return legal_nature if is company' do
      subject.stub(:legal_nature).and_return legal_nature
      subject.stub(:company?).and_return false
      subject.legal_nature.should eq legal_nature
    end
  end

  context '#commercial_registration_date' do
    let :date do
      Date.new(2012, 7, 13)
    end

    it 'should not return commercial_registration_date if is not company' do
      subject.stub(:company?).and_return false
      subject.commercial_registration_date.should be_nil
    end

    it 'should return commercial_registration_date if is company' do
      subject.stub(:commercial_registration_date).and_return date
      subject.stub(:company?).and_return false
      subject.commercial_registration_date.should eq date
    end
  end

  context '#commercial_registration_number' do
    it 'should not return commercial_registration_number if is not company' do
      subject.stub(:company?).and_return false
      subject.commercial_registration_number.should be_nil
    end

    it 'should return commercial_registration_number if is company' do
      subject.stub(:commercial_registration_number).and_return '1234'
      subject.stub(:company?).and_return false
      subject.commercial_registration_number.should eq '1234'
    end
  end
end
