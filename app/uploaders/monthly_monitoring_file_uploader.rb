class MonthlyMonitoringFileUploader < ComprasUploader
  def extension_white_list
    %w(zip)
  end
end
