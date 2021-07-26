class AttachmentUploader < ComprasUploader
  def extension_white_list
    %w(jpg jpeg png doc docx xls xlsx pdf txt)
  end
end
