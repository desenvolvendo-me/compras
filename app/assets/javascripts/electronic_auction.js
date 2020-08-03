//= require compras/eletronic_auction/unico-assets
//= require bignumber
//= require compras/currency_manipulation
//= require compras/modal_info_link_disabler
//= require compras/session_timeout
//= require compras/autocomplete_form
//= require compras/index_json
//= require compras/errors
//= require compras/eletronic_auction/jquery-3.5.1.min
//= require compras/eletronic_auction/bootstrap.bundle.min
//= require select2/select2.min
//= require select2/select2_locale_pt-BR
//= require moment.min
//= require jquery.maskedinput.min
//= require jquery.mask.min
//= require compras/unico/jquery.singlemask
//= require compras/unico/simple_form.auto_complete_input
//= require compras/unico/simple_form.masked_input
//= require compras/unico/simple_form.numeric_input
//= require compras/unico/simple_form.toogle_required_input
//= require backbone
//= require compras/init_backbone
//= require rails

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
  $(function() {
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
  });

  $("textarea.text").each(function(){
    var height = $(this).prop('scrollHeight');
    $(this).css('height', height+10 + 'px')
  })

});

