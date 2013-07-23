#encoding: utf-8
require 'unico-api'
require 'exporter_helper'
require 'app/exporters/tce_export/mg/casters/decimal_caster'

describe TceExport::MG::Casters::DecimalCaster do
  let(:generator) { double(:generator) }

  it "returns the value in the string format" do
    result = TceExport::MG::Casters::DecimalCaster.call(10.0, {})
    expect(result).to eq "1000"
  end

  it "add an error if the integer has more digits than it should" do
    options = { size: 2, attribute: "bar", generator: generator }

    generator.should_receive(:add_error).with "#{options[:attribute]} muito longo."

    TceExport::MG::Casters::DecimalCaster.call(100.0, options)
  end

  it "validates presence of required attributes" do
    options = { required: true, attribute: "bar", generator: generator }

    generator.should_receive(:add_error).with "#{options[:attribute]} não pode ficar em branco."
    TceExport::MG::Casters::DecimalCaster.call(nil, options)

    generator.should_receive(:add_error).with "#{options[:attribute]} não pode ficar em branco."
    TceExport::MG::Casters::DecimalCaster.call(' ', options)
  end

  it "returns a single space if value is nil" do
    result = TceExport::MG::Casters::DecimalCaster.call(nil, {})
    expect(result).to eq " "
  end
end
