const submitItemNameEditForm = () => {

  // IF I EVER ADD A CLICKABLE AREA/BUTTON ON ITEM SHOW, I NEED TO EXCLUDE IT FROM HERE
  // IN ORDER TO PRESERVE THE "CLICK OUTSIDE > SAVE TITLE EDITS" BEHAVIOR

  // Get the input field
  var input = document.getElementById("item-name");
  var editItemNameForm = document.getElementById("edit_item_name")

  // List of elements to exclude
  var backItemShow = document.getElementById("back-item-show")
  var itemMediumIcon = document.getElementById("item-medium-icon")
  var mediaCtn = document.getElementById("media-ctn")
  var optionsBtn = document.getElementById("options-btn")
  var options = document.getElementById("options")
  var moveToList = document.getElementById("move-to-list")
  var itemNotes = document.getElementById("txt-area")
  var saveNotes = document.getElementById("save-notes")

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

  document.addEventListener('click', function(event) {
    var isClickOnKeyArea = backItemShow.contains(event.target) || itemMediumIcon.contains(event.target) || mediaCtn.contains(event.target) || optionsBtn.contains(event.target) || options.contains(event.target) || moveToList.contains(event.target) || itemNotes.contains(event.target) || saveNotes.contains(event.target);
    if (!isClickOnKeyArea) {
      editItemNameForm.submit();
    }
  });

  editItemNameForm.addEventListener('click', function(event) {
    event.stopPropagation();
  });

}

export { submitItemNameEditForm };
