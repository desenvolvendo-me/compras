(function ($) {
  $.fn.requiredField = function ( required ) {
    var label = $('label[for|="' + $(this).attr('id') + '"]');
    var abbr = label.find('abbr');

    this.each( function() {
      if (required) {
        label.append('<abbr title="obrigatório"> *</abbr>');
      } else if ( !required ) {
        abbr.remove();
      }
    });
  }
})(jQuery);
