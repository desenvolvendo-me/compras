class Generator::GeneratorSupplyOrder < Compras::Model
  attr_accessible :supply_request_ids, :control_code

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

  delegate :organ_code, :organ_kind, to: :prefecture, allow_nil: true

  orderize 'id DESC'
  filterize

  def control_code
    return if read_attribute(:control_code).blank?

    read_attribute(:control_code).to_s.rjust(16, "0")
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
