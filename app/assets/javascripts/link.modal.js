$(document).on("click", "a.modal", function (event) {
  var modal = $('<div class="ui-modal"><div class="ui-modal-loading"></div></div>');

  modal.one('ajaxComplete', function () {
    var title = modal.find('h2');

    if (title.length) {
      modal.dialog('option', 'title', title.remove().html());
    }
  });

  modal.load($(this).prop("href")).dialog({modal: true, width: 700, height: 450});

  event.preventDefault();
});
