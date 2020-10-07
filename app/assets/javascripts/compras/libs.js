function numberFormartPt(value){
    value = value.trim();
    if(!value.includes(',') && !isNaN(parseFloat(value))){
        value = parseFloat(value).toLocaleString("pt-BR", {minimumFractionDigits:2});
        return value;
    }else{
       return value; 
    }
}
  