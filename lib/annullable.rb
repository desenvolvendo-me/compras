# This module should be used on annul records
# validates the default structure of the annul object
# should have the following column on your model:
#    employee_id  integer
#    date         date
#    description  text
module Annullable
  def self.included(receiver)
    receiver.class_eval do
      belongs_to :employee

      attr_accessible :date, :description, :employee_id

      validates :date, :employee, :presence => true
    end
  end
end
