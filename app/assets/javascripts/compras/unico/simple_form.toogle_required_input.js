(function ($) {
  $.fn.requiredField = function ( required ) {
    var label   = $('label[for|="' + $(this).attr('id') + '"]'),
        abbr    = label.children('abbr'),
        hasAbbr = (abbr.size() > 0);

    this.each( function() {
      if (!hasAbbr && required) {
        label.append('<abbr title="obrigatório"> *</abbr>');
      } else if ( !required ) {
        abbr.remove();
      }
    });
  }
})(jQuery);
