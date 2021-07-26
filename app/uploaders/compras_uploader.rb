class ComprasUploader < Uploader
  def store_dir
    "compras/#{Uploader.current_domain}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
