require 'unico-api'
require 'exporter_helper'
require 'app/exporters/tce_export/mg/casters/decimal_caster'

describe TceExport::MG::Casters::DecimalCaster do
  let(:generator) { double(:generator) }
  let(:formatter) { double(:formatter) }

  it "returns the value in the string format" do
    result = TceExport::MG::Casters::DecimalCaster.call(10.0, {})
    expect(result).to eq "1000"
  end

  it "add an error if the integer has more digits than it should" do
    options = { size: 2, attribute: "bar", generator: generator, formatter: formatter }

    formatter.should_receive(:error_description).with('bar', :size)
    generator.should_receive(:add_error).with "#{options[:attribute]} muito longo."
    generator.should_receive(:add_error_description)

    TceExport::MG::Casters::DecimalCaster.call(100.0, options)
  end

  it "validates presence of required attributes" do
    options = { required: true, attribute: "bar", generator: generator, formatter: formatter }

    formatter.should_receive(:error_description).with('bar', :required)
    generator.should_receive(:add_error).with "#{options[:attribute]} não pode ficar em branco."
    generator.should_receive(:add_error_description)
    TceExport::MG::Casters::DecimalCaster.call(nil, options)

    formatter.should_receive(:error_description).with('bar', :required)
    generator.should_receive(:add_error).with "#{options[:attribute]} não pode ficar em branco."
    generator.should_receive(:add_error_description)
    TceExport::MG::Casters::DecimalCaster.call(' ', options)
  end

  it "returns a single space if value is nil" do
    result = TceExport::MG::Casters::DecimalCaster.call(nil, {})
    expect(result).to eq " "
  end
end
