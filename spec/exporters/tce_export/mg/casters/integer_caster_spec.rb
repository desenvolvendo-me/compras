require 'unico-api'
require 'exporter_helper'
require 'app/exporters/tce_export/mg/casters/integer_caster'

describe TceExport::MG::Casters::IntegerCaster do
  let(:generator) { double(:generator) }
  let(:formatter) { double(:formatter) }

  it "returns the value in the string format" do
    result = TceExport::MG::Casters::IntegerCaster.call(10, {})
    expect(result).to eq "10"
  end

  it "add an error if the integer has more digits than it should" do
    options = { size: 2, attribute: "number", generator: generator, formatter: formatter }

    formatter.should_receive(:error_description).with('number', :size)
    generator.should_receive(:add_error_description)
    generator.should_receive(:add_error).with "#{options[:attribute]} muito longo."

    TceExport::MG::Casters::IntegerCaster.call(100, options)
  end

  it "completes value min size with zeroes" do
    options = { min_size: 8 }
    result = TceExport::MG::Casters::IntegerCaster.call(8, options)
    expect(result).to eq "00000008"
  end

  it "doesn't pad the number if it's nil, just return an empty space" do
    options = { min_size: 8 }
    result = TceExport::MG::Casters::IntegerCaster.call(nil, options)
    expect(result).to eq " "
  end

  it "validates presence of required attributes" do
    options = { required: true, attribute: "number", generator: generator, formatter: formatter }

    formatter.should_receive(:error_description).with('number', :required)
    generator.should_receive(:add_error_description)
    generator.should_receive(:add_error).with "#{options[:attribute]} não pode ficar em branco."
    TceExport::MG::Casters::IntegerCaster.call(nil, options)

    formatter.should_receive(:error_description).with('number', :required)
    generator.should_receive(:add_error_description)
    generator.should_receive(:add_error).with "#{options[:attribute]} não pode ficar em branco."
    TceExport::MG::Casters::IntegerCaster.call(' ', options)
  end
end
