require 'unico-api'
require 'exporter_helper'
require 'app/exporters/tce_export/mg/casters/text_caster'

describe TceExport::MG::Casters::TextCaster do
  let(:generator) { double(:generator) }
  let(:formatter) { double(:formatter) }

  it "returns the value in the string format" do
    result = TceExport::MG::Casters::TextCaster.call("foo", {})
    expect(result).to eq "foo"
  end

  it "returns the value with all semicolon replaced by comma" do
    result = TceExport::MG::Casters::TextCaster.call(";foo;bar; zoo; ;", {})
    expect(result).to eq ",foo,bar, zoo, ,"
  end

  it "add an error if the integer has more digits than it should" do
    options = { size: 2, attribute: "bar", generator: generator, formatter: formatter }

    formatter.should_receive(:error_description).with('bar', :size)
    generator.should_receive(:add_error_description)
    generator.should_receive(:add_error).with "#{options[:attribute]} muito longo."
    TceExport::MG::Casters::TextCaster.call("foo", options)
  end

  it "validates presence of required attributes" do
    options = { required: true, attribute: "bar", generator: generator, formatter: formatter }

    formatter.should_receive(:error_description).with('bar', :required)
    generator.should_receive(:add_error_description)
    generator.should_receive(:add_error).with "#{options[:attribute]} não pode ficar em branco."
    TceExport::MG::Casters::TextCaster.call(nil, options)

    formatter.should_receive(:error_description).with('bar', :required)
    generator.should_receive(:add_error_description)
    generator.should_receive(:add_error).with "#{options[:attribute]} não pode ficar em branco."
    TceExport::MG::Casters::TextCaster.call(' ', options)
  end

  it "returns a single space if nil" do
    result = TceExport::MG::Casters::TextCaster.call(nil, {})
    expect(result).to eq " "
  end

  it "returns a single space if empty" do
    result = TceExport::MG::Casters::TextCaster.call(" ", {})
    expect(result).to eq " "
  end
end
