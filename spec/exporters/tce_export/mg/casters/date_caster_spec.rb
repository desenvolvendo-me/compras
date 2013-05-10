#encoding: utf-8
require 'unit_helper'
require 'app/exporters/tce_export'
require 'app/exporters/tce_export/mg'
require 'app/exporters/tce_export/mg/casters'
require 'app/exporters/tce_export/mg/casters/validators'
require 'app/exporters/tce_export/mg/casters/date_caster'

describe TceExport::MG::Casters::DateCaster do
  it "returns the date in the DDMMYYYY format" do
    expect(described_class.call(Date.new(2012, 1, 1), {})).to eq "01012012"
  end

  it "returns one space if date is nil and not required" do
    expect(described_class.call(nil, {})).to eq " "
  end

  it "raises an error if value is required but nil was passed" do
    expect do
      expect(described_class.call(nil, { :required => true, :attribute => "data" }))
    end.to raise_error(ArgumentError, "data não pode ficar em branco.")
  end
end
