# encoding: utf-8
require 'presenter_helper'
require 'app/presenters/licitation_object_presenter'

describe LicitationObjectPresenter do
  subject do
    described_class.new(licitation_object, nil, helper)
  end

  let :licitation_object do
    double(:purchase_licitation_exemption => 500.0, :build_licitation_exemption => 300.0)
  end

  let(:helper) { double }

  it 'should return purchase_licitation_exemption_with_precision' do
    helper.should_receive(:number_with_precision).with(licitation_object.purchase_licitation_exemption).and_return("500,00")

    subject.purchase_licitation_exemption_with_precision.should eq '500,00'
  end

  it 'should return build_licitation_exemption_with_precision' do
    helper.should_receive(:number_with_precision).with(licitation_object.build_licitation_exemption).and_return("300,00")

    subject.build_licitation_exemption_with_precision.should eq '300,00'
  end
end
