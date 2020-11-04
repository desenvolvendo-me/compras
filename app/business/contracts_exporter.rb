class ContractsExporter
  def initialize(contracts,linked_contracts,contract_additives)
    @contracts  = contracts
    @count_contracts  = contracts ? (contracts.length):0
    @linked_contracts  = linked_contracts
    @count_linked_contracts  = linked_contracts ? (linked_contracts.length):0
    @contract_additives  = contract_additives
    @count_contract_additives  = contract_additives ? (contract_additives.length):0
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
      style4 = ws.styles.add_style(:alignment => {:horizontal=> :left})

      ws.add_row ['RELATÓRIO DE CONTRATOS'], style: style1
      ws.merge_cells("A1:K1")
      ws.add_row ContractReportDecorator.header_attributes.map{|x| x.mb_chars.upcase}, style: style2

      contracts.each do |contract|
        ws.add_row [contract.contract_number, contract.year, contract.creditor,
                          contract.decorator.publication_date, contract.contract_validity, contract.content,
                          contract.decorator.contract_value, contract.modality_humanize, contract.decorator.start_date,
                          contract.decorator.end_date, contract.status], style: style4
      end

      ws.column_widths 20,10,50,25,20,80,25,20,20,20,20

      ws.add_row [""], style: style3
      ws.add_row ["RELATÓRIO DE CONTRATOS VÍNCULADOS"], style: style1
      ws.merge_cells("A#{@count_contracts+4}:K#{@count_contracts+4}")
      ws.add_row LinkedContractReportDecorator.header_attributes.map{|x| x.mb_chars.upcase}, style: style2
      
      if @linked_contracts
        @linked_contracts.each do |linked_contract|
          ws.add_row [
            linked_contract.contract_number,
            (I18n.l(linked_contract.start_date_contract) if linked_contract.start_date_contract),
            (I18n.l(linked_contract.end_date_contract) if linked_contract.end_date_contract),
            linked_contract.contract.try(:creditor).person.try(:name)
          ], style: style4
        end
      end

      ws.add_row [""], style: style3
      ws.add_row ["RELATÓRIO DE ADITIVOS/APOSTILAMENTO"], style: style1
      ws.merge_cells("A#{@count_contracts+4+@count_linked_contracts+3}:K#{@count_contracts+4+@count_linked_contracts+3}")
      ws.add_row ContractAdditiveReportDecorator.header_attributes.map{|x| x.mb_chars.upcase}, style: style2
      
      if @contract_additives
        @contract_additives.each do |contract_additive|
          ws.add_row [
            contract_additive.number,
            contract_additive.additive_kind_humanize,
            contract_additive.additive_type_humanize,
            ( I18n.l(contract_additive.start_validity) if contract_additive.start_validity ),
            ( I18n.l(contract_additive.end_validity) if contract_additive.end_validity )
          ], style: style4
        end
      end
      
    end
    filename = "/tmp/contracts_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
    wb.serialize(filename)

    filename
  end


  private

  attr_reader :contracts
end
