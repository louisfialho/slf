import Typed from 'typed.js';

const loadDynamicBannerText = () => {
  new Typed('#banner-typed-text', {
    strings: ["Save, organize and annotate <span style='white-space:nowrap;'>resources 📚</span>"
    , "Save, organize and annotate <span style='white-space:nowrap;'>blog posts 📄</span>"
    , "Save, organize and annotate <span style='white-space:nowrap;'>news articles 📰</span>"
    , "Save, organize and annotate <span style='white-space:nowrap;'>newsletters 🗞</span>"
    , "Save, organize and annotate <span style='white-space:nowrap;'>books 📕</span>"
    , "Save, organize and annotate <span style='white-space:nowrap;'>audio books 🎧</span>"
    , "Save, organize and annotate <span style='white-space:nowrap;'>research papers 📃</span>"
    ],
    typeSpeed: 50,
    loop: true
  });
}

export { loadDynamicBannerText };
