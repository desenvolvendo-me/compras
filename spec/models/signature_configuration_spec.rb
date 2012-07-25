# encoding: utf-8
require 'model_helper'
require 'app/models/signature_configuration'
require 'app/models/signature_configuration_item'

describe SignatureConfiguration do
  it 'should return report_humanize as to_s' do
    subject.stub(:report_humanize).and_return('Autorizações de Fornecimento')
    subject.to_s.should eq 'Autorizações de Fornecimento'
  end

  it { should have_many(:signature_configuration_items).dependent(:destroy).order(:order) }

  it { should validate_presence_of :report }

  context 'check duplicated items' do
    let :signature do
      double('Signature', :id => 1)
    end

  it "the duplicated orders and signatures should be invalid except the first" do
      item_one = subject.signature_configuration_items.build(:order => '10')
      item_two = subject.signature_configuration_items.build(:order => '10')

      item_one.stub(:signature => signature)
      item_two.stub(:signature => signature)

      subject.valid?

      item_one.errors.messages[:order].should be_nil
      item_two.errors.messages[:order].should include "já está em uso"

      item_one.errors.messages[:signature].should be_nil
      item_two.errors.messages[:signature].should include "já está em uso"
    end
  end
end
