const displayAddBtns = () => {
  const plus = document.getElementById("plus");
  const btns = document.querySelector(".btns");
  plus.addEventListener("click", (event) => {
    if (btns.style.display === "none") {
      btns.style.display = "";
    } else {
      btns.style.display = "none";
    }
    plus.classList.toggle("fa-rotate-45");
});
}

export { displayAddBtns };
