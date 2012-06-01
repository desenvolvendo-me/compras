class CreditorRepresentative < ActiveRecord::Base
  attr_accessible :creditor_id, :representative_person_id

  belongs_to :creditor
  belongs_to :representative_person, :class_name => 'Person'

  delegate :name, :identity_document, :to => :representative_person, :allow_nil => true
end
