(function ($) {
  $.fn.requiredField = function ( required ) {
    if (required){
      var field = 'label[for|="' + $(this).attr('id') + '"]';
      $(field).append('<abbr title="obrigatório">*</abbr>');
    } else {
      var field = 'label[for|="' + $(this).attr('id') + '"] abbr';
      $(field).remove();
    }
  }
})(jQuery);
