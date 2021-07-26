function hasItemAlreadyAdded(item) {
    var added = false;
    $("table#authorized_areas-records input.department-id").each(function () {
        console.log(item)

        if ($(this).val() == item.id) {
            added = true;
            return added;
        }
    });
    return added;
}

function mergeItem(item) {
    var record = $('tr#department-id-' + item.id);
    var department = record.find('input.department').val();

    record.find("td.department").text(department);
    record.find('input.department').val(department);
}

function renderItem(item) {
    console.log()
    var itemBinds = {
        uuid: _.uniqueId('fresh-'),
        id: '',
        department_id: item.id,
        department: item.value
    };

    var data = $('#contract_departments_template').mustache(itemBinds);
    $('#authorized_areas-records tbody').append(data).trigger("nestedGrid:afterAdd");
}

$(document).ready(function () {
    $("#add_all_departments").on("click", function () {
        var secretary_id = $("#contract_secretary_id").val()
        if (secretary_id) {
            $.ajax({
                    url: Routes.departments,
                    data: {by_secretary: secretary_id},
                    dataType: 'json',
                    type: 'GET',
                    success: function (data) {
                        $.each(data, function (i, supply_request) {
                            if (hasItemAlreadyAdded(supply_request)) {
                                mergeItem(supply_request);
                            } else {
                                renderItem(supply_request);
                            }
                        });
                    }
                }
            );
        }
    });

  $("#contract_secretary_id2").change(function(){
    var params = {},
      url = Routes.expenses;

    params = {
      by_secretary: $(this).val()
    };

    url += "?" + $.param(params);

    $("#contract_expense").attr('data-source', url);
  });

  $('#creditor-dialog').on('click', '.creditor-choosed', function(){
    var creditor_id = $(this).data('creditor');
    var creditor_name = $(this).find('td').html();
    fillCreditorField(creditor_name, creditor_id);
    $('#creditor-dialog').dialog('close');
  });

  function showToChooseCreditor(creditors){
    var body = '';
    $.each(creditors, function(index, creditor){
      body += "<tr class='creditor-choosed' data-creditor='"+ creditor.id +"' > <td> "+creditor.name+" </td> </tr>";
    });

    $("#choose-creditor tbody").html(body);
    $("#creditor-dialog").dialog("open");
  }

  $('form').on('change', '#contract_licitation_process_id', function (event, licitationProcess) {
    var url = Routes.licitation_process_show.replace(":id", this.value);

    $.getIndex(url, {}, function (licitationProcess) {
      if (licitationProcess) {
        $('#contract_content').val(licitationProcess.description);
        $('#contract_modality_humanize').val(licitationProcess.modality_humanize);
        $('#contract_execution_type').val(licitationProcess.execution_type);
        $('#contract_contract_guarantees').val(licitationProcess.contract_guarantees);
        var creditor = licitationProcess.creditors_without_contract;
        if (creditor.length > 0) {
          if (creditor.length > 1) {
            setUrlToCreditor(licitationProcess.id);
            showToChooseCreditor(licitationProcess.creditors);
          } else {
            setUrlToCreditor(licitationProcess.id);
            if (creditor[0]) {
              fillCreditorField(creditor[0].name, creditor[0].id);
            }
          }
        }else{
          alert('O Processo de Compras selecionado não possui fornecedores vencedores.')
          clearModalityExecutionType();
          var url = Routes.creditors + "?";

          $('#contract_creditor').data("source", url);
        }

      } else {
        clearModalityExecutionType();
        var url = Routes.creditors + "?";

        $('#contract_creditor').data("source", url);
      }
    });
  });

  function setUrlToCreditor(licitation_process_id){
    var url = Routes.creditors + "?",
      params = {by_ratification_and_licitation_process_id: licitation_process_id};
    url += jQuery.param(params);

    $('#contract_creditor').data("source", url);
  }

  function fillCreditorField(name, id){
    $('#contract_creditor')
      .val(name)
      .trigger("change");
    $('#contract_creditor_id').val(id).trigger("change");
  }

  $("#contract_creditor_id").change(function(){
    const id = $(this).val();
    lookForParentContract(id);
  });

  function lookForParentContract(creditor_id){
    $.ajax({
        url: setUrlForParent(creditor_id),
        dataType: 'json',
        type: 'GET',
        success: function (data) {
          if(data)
            fillParentField(data[0])
        }
      });
  }

  function setUrlForParent(creditor_id){
    const licitation_id = $("#contract_licitation_process_id").val();
    const params = {
      by_licitation_process: licitation_id,
      by_creditor_principal_contracts: creditor_id
    };
    var url = Routes.modal_contracts + "?";

    url += jQuery.param(params);

    $("#contract_parent").data('modal-url', url);

    return url
  }

  function fillParentField(data){
    BlockPrincipalContractBox(data.id);
    $("#contract_parent_id").val(data.id);
    $("#contract_parent").val(data.value).prop('disabled', true);
  }

  function BlockPrincipalContractBox(id){
    const contract_id = parseInt($("#contract_id").val()),
          $principal_contract = $("#contract_principal_contract");

    if(contract_id !== id)
      return $principal_contract.attr('data-disabled', 'Fornecedor já possui contrato marcado como principal.');

    $principal_contract.removeAttr('data-disabled');
  }

  $( "#creditor-dialog" ).dialog({
    autoOpen: false,
    height: 400,
    width: 500,
    modal: true,
  });

  $("#contract_contract_number").focus(function(){
    if($("#contract_type_contract option:selected").val() === 'minute'){
      if($(this).val() === '')
        $(this).val('ATA - ')
    }
  });

  $(".edit-solicitation").click(function(){
    $(this).closest('.consumption-items').find(':input').prop('disabled', false);
  });

  $(".contract_quanity").change(function(){
    var item = $(this).closest(".ratification_item"),
      qtd_contract = parseInt($(this).val()),
      qtd_attended = parseInt(item.find(".qtd_attended").data('attended')),
      result = qtd_contract - qtd_attended;

    if(result < 0) result = 0;

    item.find('.consumption').val(result)
  });

   
  contract_value = $("#contract_contract_value").val();
  $("#contract_contract_additive_value").val(contract_value);
  
  $('#contract_contract_additive_addition_validity_percent,#contract_contract_additive_suppression_validity_percent').on('mouseup keyup', function () {
      $(this).val(Math.min(100, Math.max(0, $(this).val())));
  });

  $('#contract_contract_additive_addition_validity_percent').blur(function() {
    additive_value = $("#contract_contract_additive_value").val();
    addition_validity_percent = $('#contract_contract_additive_addition_validity_percent').val();
    if(addition_validity_percent != '0'){
      $("#contract_contract_additive_addition").val(parseFloat(additive_value) * (addition_validity_percent/100));
    }
  });

  additions_or_suppressions = ['deadline_article_57_1_addition_suppression','deadline_article_57_2_addition_suppression','deadline_article_57_4_addition_suppression','deadline_article_57_symbol_1_addition_suppression'];
  additions = ['value_additions','deadline_article_57_1_addition','deadline_article_57_2_addition','deadline_article_57_4_addition','deadline_article_57_symbol_1_addition']
  suppressions = ['value_decrease','deadline_article_57_1_suppression','deadline_article_57_2_suppression','deadline_article_57_4_suppression','deadline_article_57_symbol_1_suppression']
  
  $("#contract_contract_additive_additive_type").change(function(e){
    e.preventDefault();
    if(additions.includes( $(this).val() )){
      $(".contract_contract_additive_addition_validity_percent,.contract_contract_additive_addition").parent().show();
      $("#contract_contract_additive_suppression_validity_percent,#contract_contract_additive_suppression").val(0);
      $(".contract_contract_additive_suppression_validity_percent,.contract_contract_additive_suppression").parent().hide();
    }else if(suppressions.includes( $(this).val() )){
      $(".contract_contract_additive_suppression_validity_percent,.contract_contract_additive_suppression").parent().show();
      $("#contract_contract_additive_addition_validity_percent,#contract_contract_additive_addition").val(0);
      $(".contract_contract_additive_addition_validity_percent,.contract_contract_additive_addition").parent().hide();
    }else if(additions_or_suppressions.includes( $(this).val() )){
      $("#contract_contract_additive_suppression_validity_percent,#contract_contract_additive_suppression").val(0);
      $("#contract_contract_additive_addition_validity_percent,#contract_contract_additive_addition").val(0);
      $(".contract_contract_additive_addition_validity_percent,.contract_contract_additive_addition").parent().show();
      $(".contract_contract_additive_suppression_validity_percent,.contract_contract_additive_suppression").parent().show();
    }    
  });

  $('#contract_contract_additive_addition_validity_percent').blur(function(e) {
    e.preventDefault(); 
    additive_value = $("#contract_contract_additive_value").val();
    addition_validity_percent = $('#contract_contract_additive_addition_validity_percent').val();

    if(addition_validity_percent == '0'){
      $("#contract_contract_additive_addition").val('0');
    }else{
      additive_value = (additive_value).toString().replace('.','').replace(',','.');
      valor = parseFloat(additive_value) * (addition_validity_percent/100);
      $("#contract_contract_additive_addition").val((valor).toFixed(2));
      $("#contract_contract_additive_additive_kind_value").val((valor).toFixed(2));
    }
    $("#contract_contract_additive_addition").focus();
    $("#contract_contract_additive_additive_kind_value").focus();
  });

  $('#contract_contract_additive_suppression_validity_percent').blur(function(e) {
    e.preventDefault(); 
    additive_value = $("#contract_contract_additive_value").val();
    additive_value = parseFloat((additive_value).toString().replace('.','').replace(',','.'));

    addition = $("#contract_contract_additive_addition").val();
    suppression_validity_percent = $('#contract_contract_additive_suppression_validity_percent').val();
    addition_validity_percent = $('#contract_contract_additive_addition_validity_percent').val();

    if(suppression_validity_percent == '0'){
      $("#contract_contract_additive_suppression").val('0');
    }else{
      if( additions_or_suppressions.includes( $('#contract_contract_additive_additive_type').val() )){
        addition = (addition).toString().replace('.','').replace(',','.');
        additive_value = additive_value + (additive_value * (addition_validity_percent/100) );
        valor = additive_value - (additive_value * (suppression_validity_percent/100) );
      }else{
        valor = parseFloat(additive_value) * (suppression_validity_percent/100);
      }
      $("#contract_contract_additive_suppression").val((valor).toFixed(2));
      $("#contract_contract_additive_additive_kind_value").val((valor).toFixed(2));
    }
    $("#contract_contract_additive_suppression").focus();
    $("#contract_contract_additive_additive_kind_value").focus();
  });

});
