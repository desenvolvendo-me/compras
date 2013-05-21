#encoding: utf-8
require 'model_helper'
require 'action_view/helpers/number_helper'
require 'app/exporters/tce_export'
require 'app/exporters/tce_export/mg'
require 'app/exporters/tce_export/mg/casters'
require 'app/exporters/tce_export/mg/casters/validators'
require 'app/exporters/tce_export/mg/casters/precision_caster'

describe TceExport::MG::Casters::PrecisionCaster do
  it "returns the value in the string format with precision" do
    result = TceExport::MG::Casters::PrecisionCaster.call(10.0, precision: 4)
    expect(result).to eq "10,0000"
  end

  it "returns the value in the string format" do
    result = TceExport::MG::Casters::PrecisionCaster.call(10.0, {})
    expect(result).to eq "10,00"
  end

  it "raises an error if the integer has more digits than it should" do
    options = { :size => 2, :attribute => "bar" }
    expect {
      TceExport::MG::Casters::PrecisionCaster.call(100.0, options)
    }.to raise_error(ArgumentError, "bar muito longo.")
  end

  it "validates presence if required attribute" do
    options = { :required => true, :attribute => "bar" }
    expect {
      TceExport::MG::Casters::PrecisionCaster.call(nil, options)
    }.to raise_error(ArgumentError, "bar não pode ficar em branco.")
  end

  it "returns a single space if value is nil" do
    result = TceExport::MG::Casters::PrecisionCaster.call(nil, {})
    expect(result).to eq " "
  end
end

