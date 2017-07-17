// Code for creating multiple inputs on the fedora resource form.

(function fedoraResourceInputsScope() {

  var fedoraResourceInputs = function fedoraResourceInputSetup() {
    var form = $("#new_resources_fedora"),
      insert_here, clean_copy,
      i;

    // Ignore this if the form doesn't exist
    if (form.length === 0) {
      return false;
    }

    insert_here = form.find(".form-actions");
    clean_copy = form.find("input.form-control").clone();

    form.find("#3-more-btn").on("click", function add3BtnHndlr(e) {
      e.preventDefault();

      for(i = 0; i < 4; i++) {
        insert_here.before(clean_copy.clone());
      }
    }); //End click handler
  }; // fedoraResourceInputs function


  $(document).ready(function (){
    fedoraResourceInputs();
  });
})();
