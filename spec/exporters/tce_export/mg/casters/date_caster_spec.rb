#encoding: utf-8
require 'unico-api'
require 'exporter_helper'
require 'app/exporters/tce_export/mg/casters/date_caster'

describe TceExport::MG::Casters::DateCaster do
  let(:generator) { double(:generator) }

  it "returns the date in the DDMMYYYY format" do
    expect(described_class.call(Date.new(2012, 1, 1), {})).to eq "01012012"
  end

  it "returns one space if date is nil and not required" do
    expect(described_class.call(nil, {})).to eq " "
  end

  it "validates presence of required attributes" do
    options = { required: true, attribute: "data", generator: generator }

    generator.should_receive(:add_error).with "#{options[:attribute]} não pode ficar em branco."
    expect(described_class.call(nil, options))

    generator.should_receive(:add_error).with "#{options[:attribute]} não pode ficar em branco."
    expect(described_class.call(' ', options))
  end
end
