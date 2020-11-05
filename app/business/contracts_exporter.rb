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
      style_head = ws.styles.add_style(:bg_color => "15b7ed", :fg_color => "0a0909", b:true, sz: 14)

      style2 = ws.styles.add_style(b: true)
      style3 = ws.styles.add_style(:alignment => {:wrap_text => true})
      style4 = ws.styles.add_style(:alignment => {:horizontal=> :left})
      
      ws.add_row ['CONTRATOS / ATAS / ADITIVOS / APOSTILAMENTOS','TIPO','FORNECEDOR','OBJETO','INÍCIO DA VIGÊNCIA','FIM DA VIGÊNCIA','VR  DO CONTRATO','STATUS'], style: style_head
      ws.add_row [""], style: style3

      ws.add_row ['RELATÓRIO DE CONTRATOS'], style: style1
      ws.merge_cells("A3:H3")
      
      contracts.each do |contract|
        ws.add_row [
          contract.contract_number,
          "CONTRATO",
          contract.creditor,
          contract.content,
          contract.start_date ? "#{I18n.l(contract.start_date)}":"",
          contract.end_date ? "#{I18n.l(contract.end_date)}":"",
          contract.contract_value_currency,
          contract.end_date < Date.today ? "FINALIZADO":"VIGENTE"], style: style4
      end
      ws.column_widths 60,20,30,40,30,30,30,20

      ws.add_row [""], style: style3
      ws.add_row ["RELATÓRIO DE CONTRATOS VÍNCULADOS"], style: style1
      ws.merge_cells("A#{@count_contracts+5}:H#{@count_contracts+5}")
      
      if @linked_contracts
        @linked_contracts.each do |linked_contract|
          ws.add_row [
            linked_contract.contract_number,
            "CONTRATO VÍNCULADO",
            linked_contract.contract.try(:creditor),
            linked_contract.contract.content,
            (I18n.l(linked_contract.start_date_contract) if linked_contract.start_date_contract),
            (I18n.l(linked_contract.end_date_contract) if linked_contract.end_date_contract),
            linked_contract.contract.contract_value_currency,
            (linked_contract.end_date_contract < Date.today ? "FINALIZADO":"VIGENTE" if linked_contract.end_date_contract)
          ], style: style4
        end
      end
      ws.column_widths 60,20,30,40,30,30,30,20

      ws.add_row [""], style: style3
      ws.add_row ["RELATÓRIO DE ADITIVOS/APOSTILAMENTO"], style: style1
      ws.merge_cells("A#{@count_contracts+7+@count_linked_contracts}:H#{@count_contracts+7+@count_linked_contracts}")
      
      if @contract_additives
        @contract_additives.each do |contract_additive|
          ws.add_row [
            contract_additive.number,
            contract_additive.additive_kind_humanize.mb_chars.upcase,
            contract_additive.contract.try(:creditor),
            contract_additive.contract.content,
            ( I18n.l(contract_additive.start_validity) if contract_additive.start_validity ),
            ( I18n.l(contract_additive.end_validity) if contract_additive.end_validity ),
            contract_additive.contract.contract_value_currency,
            (contract_additive.end_validity < Date.today ? "FINALIZADO":"VIGENTE"  if contract_additive.end_validity)
          ], style: style4
        end
      end
      ws.column_widths 60,20,30,40,30,30,30,20

    end
    filename = "/tmp/contracts_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
    wb.serialize(filename)

    filename
  end


  private

  attr_reader :contracts
end
