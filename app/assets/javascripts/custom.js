$(document).ready(function(){
 $('#check_all').on("click", function() {
    // grouping all the checkbox using the classname
    var checkboxes = $('input[type="checkbox"]');
    // check whether checkboxs are selected.
    if(checkboxes.prop("checked")){
        // if they are selected,uncheck all the checkbox
        checkboxes.prop("checked",false);
    }
    else {
        // if they are not selected, check all the checkbox
        checkboxes.prop("checked",true);
    }


});
})