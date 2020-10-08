class ContractsExporter
  def initialize(object)
    @contracts  = object
  end

  def self.create!(*args)
    new(*args).generate!
  end

  def generate!
    wb = Axlsx::Package.new
    wb.workbook.add_worksheet(name: "Pagina 1") do |ws|
      style1 = ws.styles.add_style(:bg_color => "3B6A9B", :fg_color => "FFFFFF", b:true, sz: 14)
      style2 = ws.styles.add_style(b: true)
      style3 = ws.styles.add_style(:alignment => {:wrap_text => true})

      ws.add_row ['RELATÓRIO DE CONTRATOS'], style: style1
      ws.merge_cells("A1:K1")
      ws.add_row ContractReportDecorator.header_attributes.map{|x| x.mb_chars.upcase}, style: style2

      contracts.each do |contract|
        ws.add_row [contract.contract_number, contract.year, contract.creditor,
                          contract.decorator.publication_date, contract.contract_validity, contract.content,
                          contract.decorator.contract_value, contract.modality_humanize, contract.decorator.start_date,
                          contract.decorator.end_date, contract.status], style: style3
      end

      ws.column_widths 20,10,50,25,20,80,25,20,20,20,20
    end
    filename = "/tmp/contracts_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
    wb.serialize(filename)

    filename
  end


  private

  attr_reader :contracts
end
