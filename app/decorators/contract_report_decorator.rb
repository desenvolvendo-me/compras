class ContractReportDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper


  def self.header_attributes
    [I18n.t('activemodel.attributes.contract_report.contract_number').mb_chars.upcase,
     I18n.t('activemodel.attributes.contract_report.year').mb_chars.upcase,
     I18n.t('activemodel.attributes.contract_report.creditor').mb_chars.upcase,
     I18n.t('activemodel.attributes.contract_report.publication_date').mb_chars.upcase,
     I18n.t('activemodel.attributes.contract_report.contract_validity').mb_chars.upcase,
     I18n.t('activemodel.attributes.contract_report.content').mb_chars.upcase,
     I18n.t('activemodel.attributes.contract_report.contract_value').mb_chars.upcase,
     I18n.t('activemodel.attributes.contract_report.modality').mb_chars.upcase,
     I18n.t('activemodel.attributes.contract_report.start_date').mb_chars.upcase,
     I18n.t('activemodel.attributes.contract_report.end_date').mb_chars.upcase,
     I18n.t('activemodel.attributes.contract_report.status').mb_chars.upcase]
  end
end