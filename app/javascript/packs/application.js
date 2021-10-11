// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require('dotenv').config();

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
import { adjustTextContentSize } from '../components/adjust-text-content-size';
import { displayItemOptions } from '../components/item-options';
import { displayShelfOptions } from '../components/shelf-options';
import { displaySpaceOptions } from '../components/space-options';
import { displayAddOptions } from '../components/add-options';
import { moveToSpaceList } from '../components/move-to-space-list';
import { backArrow } from '../components/back-arrow';
import { loadDynamicBannerText } from '../components/banner';
import { displayIntlTelInpt } from '../components/intl-tel-inpt';
import { shakeHandsRedirect } from '../components/shake-hands-redirect';
// import { addFirstResource } from '../components/add-first-resource-redirect';
import { autoplayWhenVisible } from '../components/autoplay-when-visible';
import { displayIntroMessage } from '../components/display-intro-message';
import { displayItemMediaOptions } from '../components/display-item-media-options';
// import { textToSpeech } from '../components/text-to-speech';
import { textToSpeech2 } from '../components/text-to-speech2';

document.addEventListener('turbolinks:load', () => {

  if (document.querySelector("#update-status")) {
    updateStatus();
  }

  if (document.getElementById("text-content")) {
     adjustTextContentSize();
  }

  if (document.querySelector(".item-options")) {
    displayItemOptions();
    // textToSpeech();
    textToSpeech2();
  }

  if (document.querySelector("#new-object-or-space")) {
    displayAddOptions();
  }

  if (document.querySelector(".shelf-options")) {
    displayShelfOptions();
  }

  if (document.querySelector(".space-options")) {
    displaySpaceOptions();
  }

  if (document.getElementById('top-element')) {
    moveToSpaceList();
  }

  if (document.getElementById('left-arrow-img')) {
    backArrow();
  }

  if (document.getElementById('banner-typed-text')) {
    loadDynamicBannerText();
  }

  if (document.getElementById('new_user')) {
    displayIntlTelInpt();
  }

  if (document.getElementById('shake-hands')) {
    shakeHandsRedirect();
  }

  // if (document.getElementById('add-first-resource')) {
  //   addFirstResource();
  // }

  if (document.querySelector(".lp-video")) {
    autoplayWhenVisible();
  }

  if (document.querySelector(".intro-message-ctn")) {
    displayIntroMessage();
  }

  if (document.querySelector("#item-medium-icon")) {
    displayItemMediaOptions();
  }
});

import "controllers"
