# encoding: utf-8
require 'model_helper'
require 'app/models/person'
require 'app/models/employee'
require 'app/models/provider'
require 'app/models/economic_registration'
require 'app/models/licitation_process_impugnment'
require 'app/models/licitation_process_appeal'

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
      subject.stub(:personable_type).and_return("Company")
      subject.company?.should be_true
    end

    it "should not be a company" do
      subject.stub(:personable_type).and_return("Individual")
      subject.company?.should be_false
    end
  end

  it { should belong_to :personable }
  it { should have_one :employee }
  it { should have_many(:providers).dependent(:restrict) }

  it { should have_many(:providers).dependent(:restrict) }
  it { should have_many(:economic_registrations).dependent(:restrict) }
  it { should have_many(:licitation_process_impugnments).dependent(:restrict) }
  it { should have_many(:licitation_process_appeals).dependent(:restrict) }

  context "validations" do
    it "should validates phone" do
      subject.should_not be_valid
      subject.errors[:phone].should be_empty
      subject.phone = '123456'
      subject.should_not be_valid
      subject.errors[:phone].should include 'não é válido'
    end

    it "should validates fax" do
      subject.should_not be_valid
      subject.errors[:fax].should be_empty
      subject.fax = '123456'
      subject.should_not be_valid
      subject.errors[:fax].should include 'não é válido'
    end

    it "should validates phone" do
      subject.should_not be_valid
      subject.errors[:mobile].should be_empty
      subject.mobile = '123456'
      subject.should_not be_valid
      subject.errors[:mobile].should include 'não é válido'
    end

    it { should validate_presence_of :name }
    it { should validate_presence_of :personable }

    it { should allow_value('gabriel.sobrinho@gmail.com').for(:email) }
    it { should_not allow_value('missing.host').for(:email) }

    context "when personable" do
      let :personable do
        double('Personable')
      end

      it "should be special when does not have both cpf and cnpj" do
        personable.stub(:respond_to?).with(:cpf).and_return(false)
        personable.stub(:respond_to?).with(:cnpj).and_return(false)
        subject.stub(:personable => personable)

        subject.should be_special
      end

      it "should not be special if have cpf" do
        personable.stub(:respond_to?).with(:cpf).and_return(true)
        personable.stub(:respond_to?).with(:cnpj).and_return(false)
        subject.stub(:personable => personable)

        subject.should_not be_special
      end

      it "should not be special if have cnpj" do
        personable.should_receive(:respond_to?).with(:cpf).and_return(false)
        personable.should_receive(:respond_to?).with(:cnpj).and_return(true)
        subject.stub(:personable => personable)

        subject.should_not be_special
      end
    end
  end
end
