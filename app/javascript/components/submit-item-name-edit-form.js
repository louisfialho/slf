const submitItemNameEditForm = () => {

  // Get the input field
  var input = document.getElementById("item-name");
  var editItemNameForm = document.getElementById("edit_item_name")

  // Execute a function when the user releases a key on the keyboard
  input.addEventListener("keydown", function(event) {
    // Number 13 is the "Enter" key on the keyboard
    if (event.keyCode === 13) {
      // Cancel the default action, if needed
      event.preventDefault();
      // Trigger the button element with a click
      editItemNameForm.submit();
    }
  });

// if input
// if click outside
// submit form (prevent default?)

  document.addEventListener('click', function() {
    editItemNameForm.submit();
  });

  editItemNameForm.addEventListener('click', function(event) {
    event.stopPropagation();
  });

}

export { submitItemNameEditForm };
