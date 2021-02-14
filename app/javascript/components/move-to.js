const displayMoveTo = () => {
  const moveTo = document.getElementById("move-to");
  const opt = document.getElementById("options");
  const list = document.getElementById("move-to-list");
  moveTo.addEventListener('click', (event) => {
    opt.style.display = "none";
    list.style.display = "";
  });
}

export { displayMoveTo };
