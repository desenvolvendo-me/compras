#encoding: utf-8
require 'model_helper'
require 'app/exporters/tce_export'
require 'app/exporters/tce_export/mg'
require 'app/exporters/tce_export/mg/casters'
require 'app/exporters/tce_export/mg/casters/validators'
require 'app/exporters/tce_export/mg/casters/integer_caster'

describe TceExport::MG::Casters::IntegerCaster do
  it "returns the value in the string format" do
    result = TceExport::MG::Casters::IntegerCaster.call(10, {})
    expect(result).to eq "10"
  end

  it "raises an error if the integer has more digits than it should" do
    options = { size: 2, :attribute => "number" }
    expect {
      TceExport::MG::Casters::IntegerCaster.call(100, options)
    }.to raise_error(ArgumentError, "number muito longo.")
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

  it "validates if attribute is required" do
    options = { required: true, :attribute => "number" }
    expect {
      TceExport::MG::Casters::IntegerCaster.call(nil, options)
    }.to raise_error(ArgumentError, "number não pode ficar em branco.")
  end
end
