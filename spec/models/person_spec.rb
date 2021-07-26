require 'model_helper'
require 'app/models/persona/person'
require 'app/models/person'
require 'app/models/employee'
require 'app/models/licitation_process_impugnment'
require 'app/models/licitation_process_appeal'
require 'app/models/persona/partner'
require 'app/models/partner'
# require 'app/models/creditor'
require 'app/models/bidder'
require 'app/models/accredited_representative'
require 'app/models/inscriptio_cursualis/address'
require 'app/models/address'

describe Person do
  it { should have_many(:licitation_process_impugnments).dependent(:restrict) }
  it { should have_many(:licitation_process_appeals).dependent(:restrict) }
  it { should have_many :partners }
  it { should have_many(:bidders).through(:accredited_representatives) }
  it { should have_many(:accredited_representatives).dependent(:restrict) }

  it { should have_one(:creditor).dependent(:restrict) }
  it { should have_one(:street).through(:address) }
  it { should have_one(:neighborhood).through(:address) }

  it { should delegate(:city).to(:address).allowing_nil(true) }
  it { should delegate(:state).to(:address).allowing_nil(true) }
  it { should delegate(:zip_code).to(:address).allowing_nil(true) }
  it { should delegate(:benefited).to(:company_size).allowing_nil(true) }

  it "return name when call to_s" do
    subject.name = "Wenderson"
    expect(subject.to_s).to eq subject.name
  end

  it "should return an empty string on identity document when personable doesn't respond_to both cpf and cnpj" do
    expect(subject.identity_document).to eq ''
  end

  it "should return cpf on identity document when personable respond_to cpf" do
    subject.stub(:cpf).and_return('059.894.946-10')
    expect(subject.identity_document).to eq '059.894.946-10'
  end

  it "should return cnpj on identity_document when personable respond_to cnpj" do
    subject.stub(:cnpj).and_return('76.238.594/0001-35')
    expect(subject.identity_document).to eq '76.238.594/0001-35'
  end

  context 'with personable' do
    let :personable do
      double(:personable)
    end

    before do
      subject.stub(personable: personable)
    end

    describe '#company_size' do
      it 'should not return company_size if is not company' do
        expect(subject.company_size).to be_nil
      end

      it 'should return company_size if is company' do
        personable.stub(:company_size).and_return('company_size')
        expect(subject.company_size).to eq 'company_size'
      end
    end

    describe '#choose_simple' do
      it 'should not return choose_simple if is not company' do
        expect(subject.choose_simple).to be_nil
      end

      it 'should return choose_simple if is company' do
        personable.stub(:choose_simple).and_return(true)
        expect(subject.company_size).to be_false
      end
    end

    describe '#legal_nature' do
      it 'should not return legal_nature if is not company' do
        expect(subject.legal_nature).to be_nil
      end

      it 'should return legal_nature if is company' do
        personable.stub(:legal_nature).and_return('legal_nature')
        expect(subject.legal_nature).to eq 'legal_nature'
      end
    end

    describe '#commercial_registration_date' do
      it 'should not return commercial_registration_date if is not company' do
        expect(subject.commercial_registration_date).to be_nil
      end

      it 'should return commercial_registration_date if is company' do
        personable.stub(:commercial_registration_date).and_return('date')
        expect(subject.commercial_registration_date).to eq 'date'
      end
    end

    describe '#commercial_registration_number' do
      it 'should not return commercial_registration_number if is not company' do
        expect(subject.commercial_registration_number).to be_nil
      end

      it 'should return commercial_registration_number if is company' do
        personable.stub(:commercial_registration_number).and_return('1234')
        expect(subject.commercial_registration_number).to eq '1234'
      end
    end

    describe '#identity_number' do
      it 'should not return identity_number if is not individual' do
        expect(subject.identity_number).to be_nil
      end

      it 'should return identity_number if is individual' do
        personable.stub(number: '1111')
        expect(subject.identity_number).to eq '1111'
      end
    end

    describe '#company_partners' do
      it 'should return nill when does not respond to partners' do
        expect(subject.company_partners).to be_nil
      end

      it 'should return partners when respond to partners' do
        personable.stub(:partners).and_return('partners')

        expect(subject.company_partners).to eq 'partners'
      end
    end
  end

  context "#correspondence_address?" do
    it "should return true if has correspondence address" do
      subject.stub_chain(:correspondence_address, :present?).and_return(true)
      expect(subject.correspondence_address?).to be_true
    end
  end
end
