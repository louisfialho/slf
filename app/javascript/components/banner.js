import Typed from 'typed.js';

const loadDynamicBannerText = () => {
  if (window.matchMedia("(max-width: 610px)").matches) {
    new Typed('#banner-typed-text', {
      strings: ["Save, organize and <br> annotate your <br> resources &#128218;"
      , "Save, organize and <br> annotate your <br> blog posts &#128196;"
      , "Save, organize and <br> annotate your <br> news articles &#128240;"
      , "Save, organize and <br> annotate your <br> newsletters &#128478;"
      , "Save, organize and <br> annotate your <br> tweets &#128038;"
      , "Save, organize and <br> annotate your <br> podcasts &#127897;"
      , "Save, organize and <br> annotate your <br> videos &#128250;"
      , "Save, organize and <br> annotate your <br> books &#128213;"
      , "Save, organize and <br> annotate your <br> audio books &#127911;"
      ],
      typeSpeed: 50,
      loop: true
    });
  } else {
    var tagline = document.getElementById('tagline');
    tagline.innerHTML = "Save, organize and annotate <br> <span id='banner-typed-text'></span>";
    new Typed('#banner-typed-text', {
      strings: ["blog posts &#128196;"
      , "news articles &#128240;"
      , "newsletters &#128478;"
      , "tweets &#128038;"
      , "podcasts &#127897;"
      , "videos &#128250;"
      , "books &#128213;"
      , "audio books &#127911;"
      ],
      typeSpeed: 50,
      loop: true
    });
  }
}



export { loadDynamicBannerText };



