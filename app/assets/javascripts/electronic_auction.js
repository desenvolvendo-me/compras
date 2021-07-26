/** Unico Assets **/
//= require jquery
/** Unico Assets **/

//= require compras/eletronic_auction/jquery-2.2.4.min
//= require bignumber
//= require compras/currency_manipulation
//= require compras/modal_info_link_disabler
//= require compras/session_timeout
//= require compras/autocomplete_form
//= require compras/nested_grid
//= require compras/index_json
//= require compras/errors
//= require compras/eletronic_auction/bootstrap.bundle.min
//= require select2/select2.min
//= require select2/select2_locale_pt-BR
//= require moment.min
//= require jquery.maskedinput.min
//= require jquery.mask.min
//= require jquery.smartWizard.min
//= require compras/unico/jquery.singlemask
//= require compras/unico/simple_form.auto_complete_input
//= require compras/unico/simple_form.masked_input
//= require compras/unico/simple_form.numeric_input
//= require compras/unico/simple_form.toogle_required_input
//= require compras/unico/nobe
//= require compras/unico/menu
//= require compras/unico/modal_info_link
//= require compras/unico/filter
//= require compras/custom_alert


/** Unico Assets **/
//= require underscore
//= require moment
//= require moment-pt-br
//= require jquery.ui
//= require jquery.mustache
//= require jquery.price_format
//= require compras/unico/simple_form.datepicker_input
//= require simple_form.decimal_input
//= require simple_form.modal_input
//= require simple_form.load_nested_forms
//= require simple_form.nested_form
//= require link.modal
//= require currency_manipulation
//= require date
//= require select_check_boxes
//= require radio_options
//= require string
//= require disabled_element
//= require date_field_validation
//= require content_blocker
//= require rails
/** Unico Assets **/

//= require backbone
//= require compras/init_backbone


$(document).on(".clear",'click', function() {
  $(this).closest(".modal-finder").find("input.modal").val("");
});

$(document).on(".modal-finder-remove", "click", function () {
  if (!$(this).data('disabled')) {
    $(this).closest("tr").remove();
  }
  return false;
});

$(document).on(".modal-finder .modal input.modal", "change", function(event, record) {
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

