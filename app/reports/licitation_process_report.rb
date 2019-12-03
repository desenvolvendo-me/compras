class LicitationProcessReport < Report

  attr_accessor :modality,:year,:process,
                :process_date,:notice_availability_date,
                :creditor,:creditor_id,
                :process_date_start,:process_date_final

  has_enumeration_for :modality,:with => Modality

end