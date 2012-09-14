class Pdf
  attr_accessor :context, :html

  def initialize(context = DirectPurchasesController, html)
    self.context = context
    self.html = html
  end

  def generate!
    pdf_instance = PDFKit.new html

    pdf_instance.stylesheets << "#{context.request.protocol}#{context.request.host_with_port}/assets/report.css"

    pdf_instance.to_pdf
  end
end
