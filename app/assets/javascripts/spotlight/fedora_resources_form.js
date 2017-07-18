// Code for creating multiple inputs on the fedora resource form.

(function fedoraResourceInputsScope() {

  /**
   * @function
   * Captures the "Three More Fields" button and generates three more fields, up to 15.
   *
   * @param form {element} The form containing the inputs and button.
   */
  var fedoraResourceInputs = function fedoraResourceInputSetup(form) {
    var times_run = 0,
      button = form.find("#3-more-btn"),
      clean_copy = form.find("input.form-control").clone(),
      insert_here = form.find(".form-actions"),
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
  }; // fedoraResourceInputs function


  $(document).ready(function (){
    var form = $("#new_resources_fedora");
    if(form.length > 0) { fedoraResourceInputs(form); }
  });
})();
