class Generator::GeneratorSupplyOrder < Compras::Model
  attr_accessible :supply_requests_attributes, :control_code, :user_id

  attr_modal :control_code

  has_enumeration_for :status, :with => MonthlyMonitoringStatus,
                      :create_helpers => true

  mount_uploader :file, MonthlyMonitoringFileUploader do
    def store_dir
      "compras/#{model.customer.domain}/tce_export/monthly_monitoring/#{mounted_as}/#{model.id}"
    end
  end

  belongs_to :customer
  belongs_to :prefecture
  belongs_to :user

  has_many :supply_requests, class_name: "GeneratorSupplyOrderRequests", dependent: :destroy

  accepts_nested_attributes_for :supply_requests, allow_destroy: true

  delegate :organ_code, :organ_kind, to: :prefecture, allow_nil: true

  orderize 'id DESC'
  filterize

 after_create :set_control_code

  def set_control_code
    self.update_column("control_code", self.created_at.strftime("%y%m%d%H%M"))
  end

  def date
    Date.new(year, month)
  end

  def set_errors(error_messages)
    update_column :error_message, error_messages
  end

  def set_file(file)
    set_status

    self.file = file
    save!
  end

  def cancel!
    update_attribute :status, MonthlyMonitoringStatus::CANCELLED
  end

  protected

  def set_status
    error_message.blank? ? processed! : processed_with_errors!
  end

end
