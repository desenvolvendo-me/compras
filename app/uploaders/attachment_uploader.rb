class AttachmentUploader < ComprasUploader
  def store_dir
    "compras/#{Uploader.current_domain}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg png doc docx xls xlsx pdf txt)
  end
end
