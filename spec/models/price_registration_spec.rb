# encoding: utf-8
require 'model_helper'
require 'app/models/direct_purchase'
require 'app/models/price_registration'
require 'app/models/price_registration_item'

describe PriceRegistration do
  it { should belong_to :delivery_location }
  it { should belong_to :licitation_process }
  it { should belong_to :management_unit }
  it { should belong_to :payment_method }
  it { should belong_to :responsible }

  it { should have_many(:items).dependent(:destroy) }

  it { should have_one(:direct_purchase).dependent(:restrict) }
  it { should have_one(:judgment_form).through(:licitation_process) }

  it { should validate_presence_of :licitation_process }
  it { should validate_presence_of :year }

  it 'should id as to_s' do
    subject.number = 1
    subject.year = 2012

    expect(subject.to_s).to eq '1/2012'
  end

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('212').for(:year) }
  it { should_not allow_value('2a12').for(:year) }

  it { should auto_increment(:number).by(:year) }

  describe 'validate validaty_date' do
    context 'when before a year of date' do
      it 'should allow' do
        subject.stub(:date => Date.today)
        subject.stub(:validaty_date => Date.tomorrow)

        subject.valid?

        expect(subject.errors[:validaty_date]).to_not include("não poderá ser superior a um ano de acordo com Decreto Nº 2.743, de 21 de agosto de 1998")
      end
    end

    context 'when equals one year after date' do
      it 'should allow' do
        subject.stub(:date => Date.today)
        subject.stub(:validaty_date => Date.today + 1.year)

        subject.valid?

        expect(subject.errors[:validaty_date]).to_not include("não poderá ser superior a um ano de acordo com Decreto Nº 2.743, de 21 de agosto de 1998")
      end
    end

    context 'when greater than one year after date' do
      it 'should allow' do
        subject.stub(:date => Date.today)
        subject.stub(:validaty_date => Date.tomorrow + 1.year)

        subject.valid?

        expect(subject.errors[:validaty_date]).to include("não poderá ser superior a um ano de acordo com Decreto Nº 2.743, de 21 de agosto de 1998")
      end
    end

    context 'when equals date' do
      it 'should allow' do
        subject.stub(:date => Date.today)
        subject.stub(:validaty_date => Date.today)

        subject.valid?

        expect(subject.errors[:validaty_date]).to include("deve ser depois de #{I18n.l(Date.today)}")
      end
    end

    context 'when before date' do
      it 'should allow' do
        subject.stub(:date => Date.today)
        subject.stub(:validaty_date => Date.yesterday)

        subject.valid?

        expect(subject.errors[:validaty_date]).to include("deve ser depois de #{I18n.l(Date.today)}")
      end
    end
  end
end
