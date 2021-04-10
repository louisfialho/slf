// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "bootstrap";
import { updateStatus } from '../components/update';
import { displaySave } from '../components/display-save';
import { displayItemOptions } from '../components/item-options';
import { displayAddOptions } from '../components/add-options';
import { moveToSpaceList } from '../components/move-to-space-list';
// import { initSortableShelf } from '../components/init_sortable';
// import { initSortableSpace } from '../components/init_sortable';


// Internal imports, e.g:
// import { initSelect2 } from '../components/init_select2';

document.addEventListener('turbolinks:load', () => {

  if (document.querySelector("#update-status")) {
    updateStatus();
  }

  if (document.querySelector("#txt-area")) {
     displaySave();
  }

  if (document.querySelector("#options-btn")) {
    displayItemOptions();
  }

  if (document.querySelector("#add-btn")) {
    displayAddOptions();
  }

  if (document.getElementById('top-element')) {
    moveToSpaceList();
  }

  // // if (document.querySelector("#results-shelf")) {
  // //   initSortableShelf();
  // // }

  // // if (document.querySelector("#results-space")) {
  // //   initSortableSpace();
  // }
});




import "controllers"
