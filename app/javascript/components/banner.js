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
      ],
      typeSpeed: 50,
      loop: true
    });
  }

//   new Typed('#benefit-1-typed-text', {
//         strings: ["1. <u>Save</u> your resources &#128218;"
//         , "1. <u>Save</u> your blog posts &#128196;"
//         , "1. <u>Save</u> your news articles &#128240;"
//         , "1. <u>Save</u> your newsletters &#128478;"
//         , "1. <u>Save</u> your podcasts &#127897;"
//         , "1. <u>Save</u> your videos &#128250;"
//         , "1. <u>Save</u> your books &#128213;"
//         , "1. <u>Save</u> your audio books &#127911;"
//         ],
//         typeSpeed: 50,
//         loop: true
//       });

//   new Typed('#benefit-2-typed-text', {
//         strings: ["2. <u>Organize</u> your resources &#128218;"
//         , "2. <u>Organize</u> your blog posts &#128196;"
//         , "2. <u>Organize</u> your news articles &#128240;"
//         , "2. <u>Organize</u> your newsletters &#128478;"
//         , "2. <u>Organize</u> your podcasts &#127897;"
//         , "2. <u>Organize</u> your videos &#128250;"
//         , "2. <u>Organize</u> your books &#128213;"
//         , "2. <u>Organize</u> your audio books &#127911;"
//         ],
//         typeSpeed: 50,
//         loop: true
//       });

//   new Typed('#benefit-3-typed-text', {
//         strings: ["3. <u>Annotate</u> your resources &#128218;"
//         , "3. <u>Annotate</u> your blog posts &#128196;"
//         , "3. <u>Annotate</u> your news articles &#128240;"
//         , "3. <u>Annotate</u> your newsletters &#128478;"
//         , "3. <u>Annotate</u> your podcasts &#127897;"
//         , "3. <u>Annotate</u> your videos &#128250;"
//         , "3. <u>Annotate</u> your books &#128213;"
//         , "3. <u>Annotate</u> your audio books &#127911;"
//         ],
//         typeSpeed: 50,
//         loop: true
//       });
}



export { loadDynamicBannerText };



