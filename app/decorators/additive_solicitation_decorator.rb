class AdditiveSolicitationDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :creditor, :licitation_process

  def modality_or_type_of_removal
    "#{component.modality_number} - #{component.modality_humanize || component.type_of_removal_humanize}"
  end
end
