#encoding: utf-8
require 'exporter_helper'
require 'app/exporters/tce_export/mg/casters/text_caster'

describe TceExport::MG::Casters::TextCaster do
  it "returns the value in the string format" do
    result = TceExport::MG::Casters::TextCaster.call("foo", {})
    expect(result).to eq "foo"
  end

  it "returns the value with all semicolon replaced by comma" do
    result = TceExport::MG::Casters::TextCaster.call(";foo;bar; zoo; ;", {})
    expect(result).to eq ",foo,bar, zoo, ,"
  end

  it "raises an error if the integer has more digits than it should" do
    options = { size: 2, :attribute => "bar" }

    expect {
      TceExport::MG::Casters::TextCaster.call("foo", options)
    }.to raise_error(TceExport::MG::Exceptions::InvalidData, "bar muito longo.")
  end

  it "validates presence of required attributes" do
    options = { :required => true, :attribute => "bar" }

    expect {
      TceExport::MG::Casters::TextCaster.call(nil, options)
    }.to raise_error(TceExport::MG::Exceptions::InvalidData, "bar não pode ficar em branco.")

    expect {
      TceExport::MG::Casters::TextCaster.call(' ', options)
    }.to raise_error(TceExport::MG::Exceptions::InvalidData, "bar não pode ficar em branco.")
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
