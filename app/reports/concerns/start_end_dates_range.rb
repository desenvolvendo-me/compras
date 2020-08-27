module StartEndDatesRange
  extend ActiveSupport::Concern

  included do
    attr_accessor :start_date, :end_date

    localize :start_date, :end_date, using: :date

    validates :start_date, :end_date, presence: true
  end

  def initialize(repository, args = {})
    self.start_date = Date.today.at_beginning_of_month
    self.end_date   = Date.today.at_end_of_month

    super
  end
end
