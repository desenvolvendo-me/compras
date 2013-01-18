$('#trading_item_bid_submit').click(function() {
  return confirm(confirmationMessage());
});

function confirmationMessage(){
  var statusChecked = $('input[name="trading_item_bid[status]"]:checked').val();
  var bidderName = $('#trading_item_bid_bidder').val();
  var bidAmount = $('#trading_item_bid_amount').val();

  switch(statusChecked)
  {
    case "declined":
      return 'Confirma que o licitante ' + bidderName +  ' declinou ?';
    case "with_proposal":
      return 'Confirma a ' + stageName() + ' no valor de R$ ' + bidAmount + ' para o licitante ' + bidderName + '?';
    case "disqualified":
      return 'Confirma que o licitante ' + bidderName +  ' foi desclassificado ?';
    case "without_proposal":
      return 'Confirma que o licitante ' + bidderName +  ' não tem proposta para o item ?';
  }
}

function stageName(){
   var stage = $('#trading_item_bid_stage').val();

  switch(stage)
  {
    case "Rodada de lances":
      return 'oferta';
    case "Propostas":
      return 'proposta';
    case "Negociação":
      return 'negociação';
  }
}
