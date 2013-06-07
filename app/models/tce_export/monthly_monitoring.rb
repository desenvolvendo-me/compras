class TceExport::MonthlyMonitoring < Compras::Model
  attr_accessible :month, :year, :check_all, :only_files

  attr_modal :control_code, :month

  auto_increment :control_code, by: :year

  serialize :only_files, Array

  has_enumeration_for :month, :required => true
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

  validates :year, :month, presence: true
  validates :year, mask: "9999"

  before_save :remove_empty_values_from_only_files

  orderize 'id DESC'
  filterize

  def control_code
    return if read_attribute(:control_code).blank?

    year.to_s + read_attribute(:control_code).to_s.rjust(16, "0")
  end

  def date
    Date.new(year, month)
  end

  def set_errors(exception)
    processed_with_errors!
    self.error_message = exception.message
    self.processing_errors = exception.backtrace
    save!
  end

  def set_file(file)
    processed!
    self.file = file
    save!
  end

  def cancel!
    update_attribute :status, MonthlyMonitoringStatus::CANCELLED
  end

  protected

  def remove_empty_values_from_only_files
    self.only_files.reject!(&:blank?)
  end
end
