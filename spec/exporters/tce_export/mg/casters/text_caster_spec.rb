#encoding: utf-8
require 'model_helper'
require 'app/exporters/tce_export'
require 'app/exporters/tce_export/mg'
require 'app/exporters/tce_export/mg/casters'
require 'app/exporters/tce_export/mg/casters/validators'
require 'app/exporters/tce_export/mg/casters/text_caster'

describe TceExport::MG::Casters::TextCaster do
  it "returns the value in the string format" do
    result = TceExport::MG::Casters::TextCaster.call("foo", {})
    expect(result).to eq "foo"
  end

  it "raises an error if the integer has more digits than it should" do
    options = { size: 2, attribute: "bar" }

    expect {
      TceExport::MG::Casters::TextCaster.call("foo", options)
    }.to raise_error(ArgumentError, "bar muito longo.")
  end

  it "raises an error if value required but nil" do
    options = { required: true, attribute: "bar" }

    expect {
      TceExport::MG::Casters::TextCaster.call(nil, options)
    }.to raise_error(ArgumentError, "bar não pode ficar em branco.")
  end

  it 'raises an error if value not in multiple length' do
    options = { multiple_size: [5, 9], attribute: "bar" }

    expect {
      TceExport::MG::Casters::TextCaster.call("foo", options)
    }.to raise_error(ArgumentError, "bar com tamanho errado.")
  end

  it 'does not raise an error if value in multiple length' do
    options = { multiple_size: [5, 9], attribute: "bar" }

    expect {
      TceExport::MG::Casters::TextCaster.call("foooo", options)
    }.to_not raise_error(ArgumentError, "bar com tamanho errado.")
  end

  it 'does not raise an error if value in multiple length' do
    options = { multiple_size: [5, 9], attribute: "bar" }

    expect {
      TceExport::MG::Casters::TextCaster.call("foobarbaz", options)
    }.to_not raise_error(ArgumentError, "bar com tamanho errado.")
  end

  it "returns a single space if nil" do
    result = TceExport::MG::Casters::TextCaster.call(nil, {})
    expect(result).to eq " "
  end
end
