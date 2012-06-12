# This module should be used on annul records
# validates the default structure of the annul object
# should have the following column on your model:
#    employee_id  integer
#    date         date
#    description  text
module Annullable
  extend ActiveSupport::Concern

  included do
    attr_accessible :date, :description, :employee_id

    belongs_to :employee

    validates :date, :employee, :presence => true
  end
end
