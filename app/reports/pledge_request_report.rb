class PledgeRequestReport < Report
  include StartEndDatesRange

  attr_accessor :emission_date,:purchase_process,:purchase_process_id,
                :modality,:contract,:contract_id,:year

  has_enumeration_for :modality,:with => Modality

end
