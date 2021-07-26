// https://github.com/sobrinho/jquery.singlemask

(function ($) {

  function getPasteEvent() {
    var el = document.createElement('input'),

      name = 'onpaste';
    el.setAttribute(name, '');
    return (typeof el[name] === 'function') ? 'paste' : 'input';
  }

  var pasteEventName = getPasteEvent();



  $.fn.singlemask = function (mask) {
    $(this).on('keydown', function (event) {
      var key = event.keyCode;

      if (key < 16 || (key > 16 && key < 32) || (key > 32 && key < 41)) {
        return;
      }

      return String.fromCharCode(key).match(mask);
    }).on(pasteEventName, function () {
      this.value = $.grep(this.value, function (character) {
        return character.match(mask);
      }).join('');
    });
  }
})(jQuery);
