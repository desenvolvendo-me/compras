require 'unico-api'
require 'exporter_helper'
require 'app/exporters/tce_export/mg/casters/precision_caster'

describe TceExport::MG::Casters::PrecisionCaster do
  let(:generator) { double(:generator) }
  let(:formatter) { double(:formatter) }

  it "returns the value in the string format with precision" do
    result = TceExport::MG::Casters::PrecisionCaster.call(10.0, precision: 4)
    expect(result).to eq "10,0000"
  end

  it "returns the value in the string format" do
    result = TceExport::MG::Casters::PrecisionCaster.call(10.0, {})
    expect(result).to eq "10,00"
  end

  it "add an error if the integer has more digits than it should" do
    options = { size: 2, attribute: "bar", generator: generator, formatter: formatter }

    formatter.should_receive(:error_description).with('bar', :size)
    generator.should_receive(:add_error_description)
    generator.should_receive(:add_error).with "#{options[:attribute]} muito longo."
    TceExport::MG::Casters::PrecisionCaster.call(100.0, options)
  end

  it "validates presence if required attribute" do
    options = { required: true, attribute: "bar", generator: generator, formatter: formatter }

    formatter.should_receive(:error_description).with('bar', :required)
    generator.should_receive(:add_error_description)
    generator.should_receive(:add_error).with "#{options[:attribute]} não pode ficar em branco."
    TceExport::MG::Casters::PrecisionCaster.call(nil, options)
  end

  it "returns a single space if value is nil" do
    result = TceExport::MG::Casters::PrecisionCaster.call(nil, {})
    expect(result).to eq " "
  end
end

