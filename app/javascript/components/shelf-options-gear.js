const shelfOptionsGear = () => {

  let gearBtn = document.getElementById('gear');
  let optionsCtn = document.getElementById('options-shelf-ctn');

  gearBtn.addEventListener('click', function(event) {
    gearBtn.style.display = "none"
    optionsCtn.style.display = "flex"
  });

// Essayer d'avoir nice transition (vers la gauche one after the other)

// si options affichées et si user click n'importe ou sauf dans options,
// hide options

  document.addEventListener('click', function(event) {
    if (optionsCtn.style.display == "flex") {
        var isClickInsideOpt = optionsCtn.contains(event.target) ||  gearBtn.contains(event.target);
        if (!isClickInsideOpt) {
          optionsCtn.style.display = "none";
          gearBtn.style.display = "";
        }
    }
  });

}

export { shelfOptionsGear };
