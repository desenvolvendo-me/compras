class ConferenceXlsxGenerator
  def initialize(object)
    @contract  = object
  end

  def self.create!(*args)
    new(*args).generate!
  end

  def generate!
    wb = Axlsx::Package.new
    wb.workbook.add_worksheet(name: "Pagina 1") do |ws|
      style1 = ws.styles.add_style(:bg_color => "3B6A9B", :fg_color => "FFFFFF", b:true, sz: 14)
      style2 = ws.styles.add_style(:bg_color => "80A9D0", :fg_color => "FFFFFF", b:true)

      rows_to_financials ws, style1

      3.times {|i| ws.add_row []}

      rows_to_items ws, style1, style2

      3.times {|i| ws.add_row []}

      rows_to_balance ws, style1, style2

      ws.column_widths 10,50,20,20,20,15
    end
    filename = "/tmp/contract_#{contract.id}_conference_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
    wb.serialize(filename)

    filename
  end


  private

  attr_reader :contract

  def row_index ws
    ws.rows.last.index + 1
  end

  def rows_to_financials ws, style1
    ws.add_row ['DADOS FINANCEIROS'], style: style1
    ws.merge_cells("A1:E1")
    ws.add_row ['Secretaria','Projeto Atividade (Código)','Natureza','Fonte','Valor']

    contract.financials.each do |financial|
      ws.add_row [ financial.secretary, financial.project_activity_name, financial.nature_expense, financial.resource_source.to_s, financial.value]
    end
    f_count = contract.financials.count + 2
    ws.add_row ['TOTAL','','','',"=SUM(E3:E#{f_count})"]
    ws.rows.last.cells[0].b = true
    ws.rows.last.cells[4].b = true

    ws
  end


  def rows_to_items ws, style1, style2
    ws.add_row ['ITENS DO OBJETO'], style: style1
    ws.merge_cells("A#{row_index(ws)}:F#{row_index(ws)}")
    ws.add_row []
    items.each do |lot, ratifications_items|
      ws.add_row ["LOTE #{lot}"], style: style2
      ws.merge_cells("A#{row_index(ws)}:F#{row_index(ws)}")

      ws.add_row ['Código', 'Descrição', 'Unidade', 'Quantidade', 'Preço Unitário', 'Preço Total']

      initial_index = ws.rows.last.index + 1
      ratifications_items.each do |rat_item|
        ws.add_row [rat_item.material.code, rat_item.material.description, rat_item.material.reference_unit.acronym,
                    rat_item.quantity, rat_item.unit_price, rat_item.total_price]
      end

      ws.add_row ['TOTAL','','','','', "=SUM(F#{initial_index}:F#{row_index(ws)})"]
      ws.rows.last.cells[0].b = true
      ws.rows.last.cells[5].b = true

      2.times {|i| ws.add_row []}
    end

    ws
  end


  def rows_to_balance ws, style1, style2
    ws.add_row ['SALDO POR UNIDADE DE COMPRA / SECRETARIA'], style: style1
    ws.merge_cells("A#{row_index(ws)}:F#{row_index(ws)}")
    ws.add_row []
    balance_by_purchasing_unit.each do |department, purchase_solicitation_items|
      ws.add_row ["DEPARTAMENTO: #{department}"], style: style2
      ws.merge_cells("A#{row_index(ws)}:F#{row_index(ws)}")
      ws.add_row ['Código', 'Descrição', 'Unidade', 'Quantidade', 'Preço Unitário', 'Preço Total']

      initial_index = ws.rows.last.index + 1
      ordered_purchasses(purchase_solicitation_items).each do |purchase_solicitation_item|
        rat_item = ratification_item purchase_solicitation_item

        if rat_item
          ws.add_row [purchase_solicitation_item&.material&.code,
                      purchase_solicitation_item&.material&.description,
                      purchase_solicitation_item&.material&.reference_unit&.acronym,
                      purchase_solicitation_item.quantity.to_i,
                      rat_item.try(:unit_price),
                      total_price(purchase_solicitation_item, rat_item)]

        end
      end

      ws.add_row ['TOTAL','','','','',"=SUM(F#{initial_index}:F#{row_index(ws)})"]
      ws.rows.last.cells[0].b = true
      ws.rows.last.cells[5].b = true

      2.times {|i| ws.add_row []}
    end

    ws
  end


  def items
    contract.ratifications_items.
        joins(creditor:[:contracts])
        .where(compras_contracts:{id:contract.id})
        .where(unico_creditors:{id:contract.creditor}).group_by(&:lot).sort
  end

  def balance_by_purchasing_unit
    PurchaseSolicitationItem.balance_by_purchasing_unit(contract.id)
  end

  def ordered_purchasses purchase_solicitations
    PurchaseSolicitationItem.includes(:material).where(id: purchase_solicitations.map(&:id)).order("unico_materials.description")
  end

  def ratification_item purchase_solicitation_item
    LicitationProcessRatificationItem.licitation_process_id(contract.licitation_process_id)
        .creditor_id(contract.creditor_id)
        .purchase_process_item_material_id(purchase_solicitation_item&.material&.id).last
  end

  def total_price p_solicitation_item, ratifications_item
    (p_solicitation_item.quantity.to_f*ratifications_item.try(:unit_price).to_f).round(2)
  end
end
