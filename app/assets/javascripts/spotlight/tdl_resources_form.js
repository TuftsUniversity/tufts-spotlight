// Code for creating multiple inputs on the tdl resource form.

(function tdlResourceInputsScope() {

  /**
   * @function
   * Captures the "Three More Fields" button and generates three more fields, up to 15.
   *
   * @param form {element} The form containing the inputs and button.
   */
  var tdlResourceInputs = function tdlResourceInputSetup(form) {

    var times_run = 0,
      $form = $(form),
      button = $form.find(".3-more-btn"),
      clean_copy = $form.find("input.form-control").clone(),
      insert_here = $form.find(".form-actions"),
      i;

    button.on("click", function add3BtnHndlr(e) {
      e.preventDefault();

      for(i = 0; i < 3; i++) {
        insert_here.before(clean_copy.clone());
      }

      times_run++;
      if(times_run > 4) {
        $(button).attr("disabled", "true");
      }
    }); // End click handler
  }; // tdlResourceInputs function


  $(document).ready(function (){
    var forms = $(".new_resource");
    if(forms.length > 0) {
      forms.each(function() { tdlResourceInputs( this ); });
    }
  });
})();
