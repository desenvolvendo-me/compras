$(document).ready(function (){
    whenMedicineDisableFuel();
    disableMaterialIdWhenInactive();

    function whenMedicineDisableFuel(){
        let medicineCheckbox = document.getElementById('material_medicine');
        let fuelCheckbox = document.querySelector('.material_combustible');
        let fuelCheckboxValue = document.getElementById('material_combustible');

        $(medicineCheckbox).change(function(){
            if(medicineCheckbox.checked){
                fuelCheckboxValue.checked = false;
            }
            $(fuelCheckbox).toggle();
        });
    }

    function disableMaterialIdWhenInactive(){
        let materialCheckbox = document.getElementById('material_active');
        let materialCode = document.getElementById('material_code');

        if (isValueEmpty(materialCode)){
            materialCheckbox.checked = false;
        } else if (!isValueEmpty(materialCode) &&  materialCheckbox.checked) {
            $(materialCode).prop('disabled', false)
        };

        $(materialCheckbox).change(function() {
            if (!materialCheckbox.checked){
                $(materialCode).prop('disabled', true)
            } else {
                $(materialCode).prop('disabled', false)
            };
        })

        function isValueEmpty(input){
            let result = input.value.trim() === '';
            return result;
        };
    }
});