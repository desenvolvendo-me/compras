class LegalAnalysisAppraisalDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :appraisal_type, :appraisal_expedition_date, :reference, :responsible
end
