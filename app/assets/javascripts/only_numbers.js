(function ($) {
  var pasteEventName = $.browser.msie ? 'paste' : 'input';

  $.fn.onlyNumbers = function () {
    $(this).live(pasteEventName, function () {
      this.value = this.value.replace(/\D/gi, "");
    });
  }
})(jQuery);
