const displaySave = () => {
  const saveNotes = document.getElementById("save-notes");
  const txtArea = document.getElementById("txt-area");

  txtArea.addEventListener('focus', (event) => {
    saveNotes.style.display = "";
  });
}

export { displaySave };
