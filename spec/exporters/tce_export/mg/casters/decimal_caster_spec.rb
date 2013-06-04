#encoding: utf-8
require 'exporter_helper'
require 'app/exporters/tce_export/mg/casters/decimal_caster'

describe TceExport::MG::Casters::DecimalCaster do
  it "returns the value in the string format" do
    result = TceExport::MG::Casters::DecimalCaster.call(10.0, {})
    expect(result).to eq "1000"
  end

  it "raises an error if the integer has more digits than it should" do
    options = { :size => 2, :attribute => "bar" }
    expect {
      TceExport::MG::Casters::DecimalCaster.call(100.0, options)
    }.to raise_error(TceExport::MG::Exceptions::InvalidData, "bar muito longo.")
  end

  it "validates presence of required attributes" do
    options = { :required => true, :attribute => "bar" }

    expect {
      TceExport::MG::Casters::DecimalCaster.call(nil, options)
    }.to raise_error(TceExport::MG::Exceptions::InvalidData, "bar não pode ficar em branco.")

    expect {
      TceExport::MG::Casters::DecimalCaster.call(' ', options)
    }.to raise_error(TceExport::MG::Exceptions::InvalidData, "bar não pode ficar em branco.")
  end

  it "returns a single space if value is nil" do
    result = TceExport::MG::Casters::DecimalCaster.call(nil, {})
    expect(result).to eq " "
  end
end
