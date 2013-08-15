require 'unico-api'
require 'exporter_helper'
require 'app/exporters/tce_export/mg/casters/date_caster'

describe TceExport::MG::Casters::DateCaster do
  let(:generator) { double(:generator) }
  let(:formatter) { double(:formatter) }

  it "returns the date in the DDMMYYYY format" do
    expect(described_class.call(Date.new(2012, 1, 1), {})).to eq "01012012"
  end

  it "returns one space if date is nil and not required" do
    expect(described_class.call(nil, {})).to eq " "
  end

  it "validates presence of required attributes" do
    options = { required: true, attribute: "data", generator: generator, formatter: formatter }

    formatter.should_receive(:error_description).with('data', :required)
    generator.should_receive(:add_error).with "#{options[:attribute]} não pode ficar em branco."
    generator.should_receive(:add_error_description)
    expect(described_class.call(nil, options))

    formatter.should_receive(:error_description).with('data', :required)
    generator.should_receive(:add_error).with "#{options[:attribute]} não pode ficar em branco."
    generator.should_receive(:add_error_description)
    expect(described_class.call(' ', options))
  end
end
