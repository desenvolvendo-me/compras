(function ($) {
  $("div.actions a.filter").live("click", function () {
    var modal = $('<div class="ui-modal"><div class="ui-modal-loading"></div></div>');

    modal.one('ajaxComplete', function () {
      var title = modal.find('h2');

      if (title.length) {
        modal.dialog('option', 'title', title.remove().html());
      }

      modal.find(':input:focusable:not([data-modal]):first').focus();
    });

    modal.bind('dialogclose', function () {
      modal.remove();
    });

    modal.load(this.href).dialog({modal: true, width: 700, height: 450});

    return false;
  });
})(jQuery);
