const displaySave = () => {
  const saveNotes = document.getElementById("save-notes");
  const txtArea = document.getElementById("txt-area");

  txtArea.style.height = (window.innerHeight) - 450 + "px";

  txtArea.addEventListener('focus', (event) => {
    saveNotes.style.display = "";
  });
}

export { displaySave };
