import Typed from 'typed.js';

const loadDynamicBannerText = () => {
  if (window.matchMedia("(max-width: 610px)").matches) {
    new Typed('#banner-typed-text', {
      strings: ["Save, organize and <br> annotate your <br> resources &#128218;"
      , "Save, organize and <br> annotate your <br> blog posts &#128196;"
      , "Save, organize and <br> annotate your <br> news articles &#128240;"
      , "Save, organize and <br> annotate your <br> newsletters &#128478;"
      , "Save, organize and <br> annotate your <br> podcasts &#127897;"
      , "Save, organize and <br> annotate your <br> videos &#128250;"
      , "Save, organize and <br> annotate your <br> books &#128213;"
      , "Save, organize and <br> annotate your <br> audio books &#127911;"
      , "Save, organize and <br> annotate your <br> research papers &#128195;"
      ],
      typeSpeed: 50,
      loop: true
    });
  } else {
    new Typed('#banner-typed-text', {
      strings: ["Save, organize and annotate resources &#128218;"
      , "Save, organize and annotate blog posts &#128196;"
      , "Save, organize and annotate news articles &#128240;"
      , "Save, organize and annotate newsletters &#128478;"
      , "Save, organize and annotate podcasts &#127897;"
      , "Save, organize and annotate videos &#128250;"
      , "Save, organize and annotate books &#128213;"
      , "Save, organize and annotate audio books &#127911;"
      , "Save, organize and annotate research papers &#128195;"
      ],
      typeSpeed: 50,
      loop: true
    });
  }
}

export { loadDynamicBannerText };



