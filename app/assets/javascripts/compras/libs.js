function numberFormartPt(value){
    value = value.trim();
    if(!value.includes(',') && !isNaN(parseFloat(value))){
        value = parseFloat(value).toLocaleString("pt-BR", {minimumFractionDigits:2});
        return value;
    }else{
       return value; 
    }
}


function numberWithDelimiter (number, delimiter, separator, fixed) {
    try {
      delimiter = delimiter || ".";
      separator = separator || ",";
      fixed = fixed || 2;
  
      var parts = number.toFixed(fixed).split('.');
      parts[0] = parts[0].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1" + delimiter);
  
      return parts.join(separator);
    } catch (e) {
      return number;
    }
  }