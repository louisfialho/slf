const backArrow = () => {
  const backArrow = document.getElementById("left-arrow-img");
  backArrow.addEventListener("click", (event) => {
    history.back()
  })
}

export { backArrow };

