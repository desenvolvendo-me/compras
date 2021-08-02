$(document).ready(function (){
    whenMedicineDisableFuel();

    function whenMedicineDisableFuel(){
        const medicineCheckbox = document.getElementById('material_medicine');
        const fuelCheckbox = document.querySelector('.material_combustible');
        const fuelCheckboxValue = document.getElementById('material_combustible');

        $(medicineCheckbox).change(function(){
            verifyMedicineAndFuelCheckbox();
        });

        verifyMedicineAndFuelCheckbox();

        function verifyMedicineAndFuelCheckbox(){
            if(medicineCheckbox.checked){
                fuelCheckboxValue.checked = false;
                $(fuelCheckbox).hide();
            } else {
                $(fuelCheckbox).show();
            }
        };
    }
});