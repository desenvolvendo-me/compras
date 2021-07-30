$(document).ready(function (){
    whenMedicineDisableFuel();

    function whenMedicineDisableFuel(){
        var medicineCheckbox = document.getElementById('material_medicine');
        var fuelCheckbox = document.querySelector('.material_combustible');
        var fuelCheckboxValue = document.getElementById('material_combustible');

        $(medicineCheckbox).change(function(){
            if(medicineCheckbox.checked){
                fuelCheckboxValue.checked = false;
            }
            $(fuelCheckbox).toggle();
        });
    }
});



