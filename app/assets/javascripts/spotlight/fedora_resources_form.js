// Code for creating multiple inputs on the fedora resource form.
// TODO - Button only works once

(function fedoraResourceInputsScope() {
  var fedoraResourceInputs = function() {
    var form = $("#new_resources_fedora"),
      target_input,
      i = 0;

    // Ignore this if the form doesn't exist.
    if (form.length === 0) {
      return false;
    }

    target_input = form.find("input.form-control");

    form.find("#3-more-btn").on("click", function add5BtnHndlr(e) {
      e.preventDefault();

      for(i; i < 4; i++) {
        target_input.after(target_input.clone());
      }
    });
  };

  $(document).ready(function (){
    fedoraResourceInputs();
  });
})();
