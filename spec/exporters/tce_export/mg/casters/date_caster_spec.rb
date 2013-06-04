#encoding: utf-8
require 'exporter_helper'
require 'app/exporters/tce_export/mg/casters/date_caster'

describe TceExport::MG::Casters::DateCaster do
  it "returns the date in the DDMMYYYY format" do
    expect(described_class.call(Date.new(2012, 1, 1), {})).to eq "01012012"
  end

  it "returns one space if date is nil and not required" do
    expect(described_class.call(nil, {})).to eq " "
  end

  it "validates presence of required attributes" do
    options = { :required => true, :attribute => "data" }

    expect do
      expect(described_class.call(nil, options))
    end.to raise_error(TceExport::MG::Exceptions::InvalidData, "data não pode ficar em branco.")

    expect do
      expect(described_class.call(' ', options))
    end.to raise_error(TceExport::MG::Exceptions::InvalidData, "data não pode ficar em branco.")
  end
end
