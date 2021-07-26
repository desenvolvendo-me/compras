class SupplyRequestAttendance < Compras::Model
  attr_accessible :date, :justification, :responsible_id,
                  :supply_request_id, :service_status

  has_enumeration_for :service_status, :with => SupplyRequestServiceStatus,
                      :create_helpers => true

  belongs_to :responsible, :class_name => 'Employee', :foreign_key => :responsible_id
  belongs_to :supply_request

  validates :date, :service_status,
            :supply_request, :presence => true
  validates :date, :timeliness => {:type => :date}, :allow_blank => true

  auto_increment :sequence, :by => :supply_request_id

  orderize :justification
  filterize

  def to_s
    sequence.to_s
  end

end
