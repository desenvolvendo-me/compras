(function ($) {
  $.fn.requiredField = function ( required ) {
    if (required){
      this.each( function() {
        var field = 'label[for|="' + $(this).attr('id') + '"]';
        $(field).append('<abbr title="obrigatório"> *</abbr>');
      });
    } else {
      this.each( function() {
        var field = 'label[for|="' + $(this).attr('id') + '"] abbr';
        $(field).remove();
      });
    }
  }
})(jQuery);
