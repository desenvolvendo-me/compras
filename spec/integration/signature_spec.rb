# encoding: utf-8
require 'spec_helper'

describe Signature do
  before do
    Signature.make!(:gerente_sobrinho)

    subject.kind = SignatureKind::MANAGER
  end

  context 'validate date range' do
    context 'to start_date' do
      it 'less than other start_date' do
        expect(subject).to allow_value(Date.new(2011, 6, 30)).for(:start_date)
      end

      it 'equals to other start_date' do
        expect(subject).to_not allow_value(Date.new(2012, 1, 1)).for(:start_date).with_message('já está contida em outra assinatura')
      end

      it 'equals to other end_date' do
        expect(subject).to_not allow_value(Date.new(2012, 12, 31)).for(:start_date).with_message('já está contida em outra assinatura')
      end

      it 'between other start_date and end_date' do
        expect(subject).to_not allow_value(Date.new(2012, 5, 20)).for(:start_date).with_message('já está contida em outra assinatura')
      end

      it 'greater than other end_date' do
        expect(subject).to allow_value(Date.new(2013, 12, 31)).for(:start_date)
      end
    end

    context 'end_date' do
      it 'less then other start_date' do
        expect(subject).to allow_value(Date.new(2011, 1, 1)).for(:end_date)
      end

      it 'equals to other start_date' do
        expect(subject).to_not allow_value(Date.new(2012, 1, 1)).for(:end_date).with_message('já está contida em outra assinatura')
      end

      it 'equals to other end_date' do
        expect(subject).to_not allow_value(Date.new(2012, 12, 31)).for(:end_date).with_message('já está contida em outra assinatura')
      end

      it 'between other start_date and end_date' do
        expect(subject).to_not allow_value(Date.new(2012, 6, 30)).for(:end_date).with_message('já está contida em outra assinatura')
      end

      it 'greater than other end_date' do
        expect(subject).to allow_value(Date.new(2013, 6, 30)).for(:end_date)
      end
    end
  end

  it 'by date range' do
    subject.start_date = Date.new(2011, 12, 1)
    subject.end_date = Date.new(2013, 2, 10)

    subject.valid?

    expect(subject.errors[:base]).to include 'intervalo de data já está contida em outra assinatura'
  end
end
