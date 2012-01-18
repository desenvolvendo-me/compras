class WorkingHour < ActiveRecord::Base
  attr_accessible :name, :initial, :beginning_interval, :end_of_interval, :final

  validates :name, :presence => true, :uniqueness => { :allow_blank => true }
  validates :initial, :final, :presence => true
  validates :initial, :timeliness => { :on_or_before => :beginning_interval }
  validates :beginning_interval, :timeliness => { :on_or_after => :initial }, :allow_blank => true
  validates :end_of_interval, :timeliness => { :on_or_after => :beginning_interval }, :allow_blank => true
  validates :final, :timeliness => { :on_or_after => :end_of_interval }

  validates :beginning_interval, :presence => true, :if => :end_of_interval?
  validates :end_of_interval,    :presence => true, :if => :beginning_interval?

  filterize
  orderize

  def to_s
    name
  end
end
