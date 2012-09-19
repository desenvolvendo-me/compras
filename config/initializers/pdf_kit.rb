PDFKit.configure do |config|
  config.default_options = {
    :page_size => 'A4',
    :print_media_type => true,
    :encoding => 'UTF-8'
  }
end
