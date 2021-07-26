$(function(){
  function hasPurchaseSolicitationAlreadyAdded(purchase_solicitation) {
    var added = false;
    $("table#list_purchase_solicitations_records input.purchase_solicitation_id").each(function () {
      if ($(this).val() == purchase_solicitation.id) {
        added = true;
        return added;
      }
    });
    return added;
  }

  function mergePurchaseSolicitation(purchase_solicitation) {

    var record = $('tr#purchase_solicitation-id-' + purchase_solicitation.id);

    record.find("td.department").text(purchase_solicitation.department);
    record.find('input.department').val(purchase_solicitation.department);
  }

  function renderPurchaseSolicitation(purchase_solicitation) {
    var purchaseSolicitationBinds = {
      uuid: _.uniqueId('fresh-'),
      id: '',
      purchase_solicitation_id: purchase_solicitation.id,
      purchase_solicitation: purchase_solicitation.code_and_year,
      department: purchase_solicitation.department
    };

    var data = $('#purchase_solicitations_template').mustache(purchaseSolicitationBinds);

    $('#purchase_solicitations-records tbody').append(data);

  }

  $("#licitation_process_demand_id").on("change", function (event, Demand) {
    dataDemands = Demand;
  });

  $("#licitation_process_purchase_solicitation_id").on("change", function (event, purchaseSolicitation) {
    DataPurchaseSolicitation = purchaseSolicitation;
  });
  
  $("#button_add_purchase_solicitations").click(function(event){
  // $("#list_purchase_solicitations_button").click(function(event){
    console.log("list_purchase_solicitations_button");
    event.preventDefault();
    event.stopPropagation();

    if(dataDemands.purchaseSolicitations){
      $.each(dataDemands.purchaseSolicitations, function (i, purchase_solicitation) {
        if (hasPurchaseSolicitationAlreadyAdded(purchase_solicitation)) {
          mergePurchaseSolicitation(purchase_solicitation);
        } else {
          renderPurchaseSolicitation(purchase_solicitation);
        }

        fillItems(purchase_solicitation.items);
      });

      dataDemands = {};
    }

    if(DataPurchaseSolicitation.items){
      if (hasPurchaseSolicitationAlreadyAdded(DataPurchaseSolicitation)) {
        mergePurchaseSolicitation(DataPurchaseSolicitation);
      } else {
        renderPurchaseSolicitation(DataPurchaseSolicitation);
      }

      fillItems(DataPurchaseSolicitation.items)

      DataPurchaseSolicitation= {};
    }

    $("#tab-requestor .nested-fields :input").val('');
  });


//   *************** inicio  ***************

//    adiciona os itens de acordo com a solicitação de compra adicionada
//    (aba solicitante)

  function money_en(value) {
    return parseFloat(value.replace('.', '').replace(',', '.').toLocaleString('en', {minimumFractionDigits: 2}))
  }

  function money_pt(value) {
    return value.toLocaleString('pt-BR', {minimumFractionDigits: 2});
  }

  function hasItemAlreadyAdded(item) {
    var added = false;
    $("table#items-records input.material-id").each(function () {
      if ($(this).val() == item.material_id) {
        added = true;
        return added;
      }
    });
    return added;
  }

  function mergeItem(item) {

    var record = $('tr#material-id-' + item.material_id),
      totalQuantity = parsePtBrFloat(record.find('input.item-quantity').val()) + item.quantity,
      itemUnitPrice = (money_en(record.find('input.item-unit-price').val()) + item.unit_price) / 2,
      itemtotalValue = money_pt(numberWithDelimiter(itemUnitPrice * totalQuantity));
    itemUnitPrice = money_pt(itemUnitPrice);


    record.find('input.item-quantity').val(totalQuantity);

    record.find('input.item-unit-price').val(itemUnitPrice);

    record.find("td.item-total-value").text(itemtotalValue);
    record.find('input.item-total-value').val(itemtotalValue);

  }

  function renderItem(item) {
    console.log(item)
    var itemBinds = {
      uuid: _.uniqueId('fresh-'),
      id: '',
      material_id: item.material_id,
      material: item.material_description,
      creditor_id: '',
      creditor: '',
      reference_unit: item.reference_unit,
      brand: item.brand,
      quantity: item.quantity,
      lot: item.lot,
      estimated_total_price:
        money_pt(item.quantity * item.unit_price),
      unit_price: money_pt(item.unit_price)
    };

    var data = $('#licitation_process_items_template').mustache(itemBinds);

    $('#items-records tbody').append(data);
  }

  function fillItems(items){

    $.each(items, function (i, item) {
      if (hasItemAlreadyAdded(item)) {
        mergeItem(item);
      } else {
        renderItem(item);
      }
    });
  }

  $("#items-records").on('nestedGrid:afterAdd', function(){
    const nestedFields = $("#items .nested-fields");

    nestedFields.find(':input').not($(".justification :input")).each(function() {
      if ($(this).hasClass('numeric')) {
        $(this).val('0,00');
      } else {
        $(this).val('');
      }
    });
  });


// controla o botão e ações de adicionar
// um fornecedor a todos os itens
  $(".btn_creditor_for_all_items").click(function(){
    $(".creditor_for_all_input").css('display', 'flex');
  });

  $("#btn_cancel_creditor_for_all").click(function(){
    $(".creditor_for_all_input").hide();
  });

  $("#btn_set_creditor_for_all_items").click(function(){
    var $creditor_for_all = $("[name$='[creditor_for_all_items]']"),
      $creditor_for_all_id = $("[name$='[creditor_for_all_items_id]']");

    if($creditor_for_all && $creditor_for_all_id){
      $("#items-records tbody [name$='[creditor]']").val($creditor_for_all.val());
      $("#items-records tbody [name$='[creditor_id]']").val($creditor_for_all_id.val());
    }
  });

});