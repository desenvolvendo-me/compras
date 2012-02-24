class OrganogramResponsible < ActiveRecord::Base
  attr_accessible :responsible_id, :administractive_act_id, :start_date, :end_date, :status

  has_enumeration_for :status

  belongs_to :organogram
  belongs_to :responsible, :class_name => 'Employee', :foreign_key => 'responsible_id'
  belongs_to :administractive_act

  validates :responsible, :administractive_act, :start_date, :end_date, :status, :presence => true
  validates :end_date, :timeliness => { :after => :start_date, :type => :date }
end
