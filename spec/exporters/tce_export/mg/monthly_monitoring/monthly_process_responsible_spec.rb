#encoding: utf-8
require 'unit_helper'
require 'typecaster'
require 'app/exporters/tce_export'
require 'app/exporters/tce_export/mg'
require 'app/exporters/tce_export/mg/casters'
require 'app/exporters/tce_export/mg/casters/validators'
require 'app/exporters/tce_export/mg/casters/integer_caster'
require 'app/exporters/tce_export/mg/casters/text_caster'
require 'app/exporters/tce_export/mg/casters/date_caster'
require 'app/exporters/tce_export/mg/monthly_monitoring'
require 'app/exporters/tce_export/mg/monthly_monitoring/monthly_process_responsible'

describe TceExport::MG::MonthlyMonitoring::MonthlyProcessResponsible do
  let(:generator) { double(:generator) }
  let(:responsible_formatter) { double(:responsible_formatter) }
  let(:member_formatter) { double(:member_formatter) }
  let(:monthly_monitoring) { double(:monthly_monitoring) }
  let(:data) { double(:data) }
  let(:member) { double(:member) }

  subject do
    described_class.new(generator: generator,
      responsible_formatter: responsible_formatter,
      member_formatter: member_formatter)
  end

  describe '#generate_file' do
    before do
      subject.stub(generate_data: [data])
    end

    it 'should generate data to file' do
      data.should_receive(:except).with(:members).and_return(data)

      responsible_formatter.should_receive(:new).with(data).and_return(responsible_formatter)
      responsible_formatter.should_receive(:to_s)

      data.should_receive(:[]).with(:members).twice.and_return([member])
      member_formatter.should_receive(:new).with(member).and_return(member_formatter)
      member_formatter.should_receive(:to_s)
      subject.generate_file(monthly_monitoring)
    end
  end
end
