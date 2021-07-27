//= require unico-assets
//= require bignumber
//= require backbone
//= require profiles
//= require compras/unico/jquery.ui.accordion
//= require compras/unico/simple_form.toogle_required_input
//= require compras/unico/simple_form.numeric_input
//= require compras/currency_manipulation
//= require compras/modal_info_link_disabler
//= require compras/session_timeout
//= require compras/unico/simple_form.auto_complete_input.js
//= require moment.min
//= require compras/autocomplete_form
//= require compras/nested_grid
//= require compras/errors
//= require compras/index_json
//= require compras/init_backbone
//= require compras/custom_alert
//= require compras/libs
//= require reports/balance_per_creditor
//= require reports/balance_per_process_and_contract
//= require select2/select2.min
//= require select2/select2_locale_pt-BR
//= require cocoon

$(".clear").live('click', function() {
  $(this).closest(".modal-finder").find("input.modal").val("");
});

$(".modal-finder-remove").live("click", function () {
  if (!$(this).data('disabled')) {
    $(this).closest("tr").remove();
  }
  return false;
});

$(".modal-finder .modal input.modal").live("change", function(event, record) {
  var id = $(this).attr("id");
  var template = "#" + id + "_template";
  var defaults = {
    index: _.uniqueId('fresh-'),
    uuid: _.uniqueId('fresh-')
  };

  var options = $.extend({}, defaults, record);

  if ($("#" + id + "_record_" + record.id + '_id').length == 0 ) {
    $("." + id + "_records").append($(template).mustache(options));
  }

  $(this).val('');
});

/* Desabilita inputs de submit após serem clicados.
 * Previne que sejam feitos mais de um request ao clicar mais de uma vez enquanto
 * a pagina ainda não redirecionou.
*/
$(document).on('click', ':submit', function(event) {
  event.preventDefault();

  $(this).attr('disabled', true);

  $(this).closest('form').submit();

  return false;
});

/* Aumenta os campos text area conforme texto inserido */
$(function(){
  $("textarea").on('keyup paste', function() {
    var $el = $(this),
      offset = $el.innerHeight() - $el.height();

    if ($el.innerHeight() < this.scrollHeight && this.scrollHeight < 400) {
      $el.height(this.scrollHeight - offset);
    } else if(this.scrollHeight > 400) {
      $el.height(1);
      this.scrollHeight < 400 ? $el.height(this.scrollHeight) : $el.height(400)
    }else{
      $el.height(1);
      $el.height(this.scrollHeight - offset);
    }
  });

  $("textarea.text").each(function(){
    var height = $(this).prop('scrollHeight');
    if( height < 10){
      $(this).css('height', height+53 + 'px')
    }else{
      $(this).css('height', height+10 + 'px')
    }
  })

});

/* Desativa o codigo do material quando o campo Ativo não estiver selecionado */
$(function(){
  var active = document.getElementById('material_active')
  var check = document.getElementById('material_code')

  active.onchange = function(){
    if(this.checked)
    {check.disabled = false;}
    else
    {check.disabled = true;}
  }
});