loadNestedForms = function() {
  $('div.nested-form[data-nested-form]').each(function() {
    var entity = $(this).data('nested-form');

    $('#' + entity + '-template').nestedForm({
      add: '.add-' + entity,
      remove: '.remove-' + entity,
      target: '#' + entity,
      uuid: 'uuid-' + entity,
      fieldToRemove: '.nested-' + entity,
      appendItem: $(this).data('append-item'),
      right: $(this).data('right')
    });
  });
}

$(loadNestedForms);
