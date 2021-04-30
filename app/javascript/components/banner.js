import Typed from 'typed.js';

const loadDynamicBannerText = () => {
  new Typed('#banner-typed-text', {
    strings: ["Save, organize and annotate resources &#128218;</span>"
    , "Save, organize and annotate blog posts &#128196;</span>"
    , "Save, organize and annotate news articles &#128240;</span>"
    , "Save, organize and annotate newsletters &#128478;</span>"
    , "Save, organize and annotate podcasts &#127897;</span>"
    , "Save, organize and annotate videos &#128250;</span>"
    , "Save, organize and annotate books &#128213;</span>"
    , "Save, organize and annotate audio books &#127911;</span>"
    , "Save, organize and annotate research papers &#128195;</span>"
    ],
    typeSpeed: 50,
    loop: true
  });
}

export { loadDynamicBannerText };
