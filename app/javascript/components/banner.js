import Typed from 'typed.js';

const loadDynamicBannerText = () => {
  new Typed('#banner-typed-text', {
    strings: ["Save, organize and annotate <span style='white-space:nowrap;'>resources &#128218;</span>"
    , "Save, organize and annotate <span style='white-space:nowrap;'>blog posts &#128196;</span>"
    , "Save, organize and annotate <span style='white-space:nowrap;'>news articles &#128240;</span>"
    , "Save, organize and annotate <span style='white-space:nowrap;'>newsletters &#128478;</span>"
    , "Save, organize and annotate <span style='white-space:nowrap;'>podcasts &#127897;</span>"
    , "Save, organize and annotate <span style='white-space:nowrap;'>videos &#128250;</span>"
    , "Save, organize and annotate <span style='white-space:nowrap;'>books &#128213;</span>"
    , "Save, organize and annotate <span style='white-space:nowrap;'>audio books &#127911;</span>"
    , "Save, organize and annotate <span style='white-space:nowrap;'>research papers &#128195;</span>"
    ],
    typeSpeed: 50,
    loop: true
  });
}

export { loadDynamicBannerText };
