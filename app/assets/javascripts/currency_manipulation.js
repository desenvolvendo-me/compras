function floatToPtBrString(value){
  return (value).toFixed(2).replace('.',',');
}

function parsePtBrFloat(value){
  return parseFloat(value.replace(/\./g,'').replace(',','.'));
}
