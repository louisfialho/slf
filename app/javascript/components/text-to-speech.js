const textToSpeech = () => {

  const { CognitoIdentityClient } = require("@aws-sdk/client-cognito-identity");
  const {
    fromCognitoIdentityPool,
  } = require("@aws-sdk/credential-provider-cognito-identity");
  const { Polly, StartSpeechSynthesisTaskCommand, GetSpeechSynthesisTaskCommand } = require("@aws-sdk/client-polly");
  const { getSynthesizeSpeechUrl } = require("@aws-sdk/polly-request-presigner");

  // Create the Polly service client, assigning your credentials
  const client = new Polly({
    region: "eu-west-2",
    credentials: {
      accessKeyId: process.env.AWS_ACCESS_KEY_ID,
      secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
    }
  });

  let listenBtn = document.getElementById("listen");

  let text = document.getElementById("text-content").innerText;
  text = text.replace(/(\r\n|\n|\r)/gm, ". ");
  text = text.replace(/([\u2700-\u27BF]|[\uE000-\uF8FF]|\uD83C[\uDC00-\uDFFF]|\uD83D[\uDC00-\uDFFF]|[\u2011-\u26FF]|\uD83E[\uDD10-\uDDFF])/g, " ");
  text = text.replace(/( —)/gm, ",");
  let textLengthChar = text.length;

  let itemId = document.getElementById("item-title").dataset.id;

  let player = document.getElementById('audioPlayback');

  let audioSource = document.getElementById('audioSource');

  let textLengthMinApprox = textLengthChar * (1/900) // assuming Matthew reads 900 chars per minute (slow estimate)

  // const shortText = async() => {
  //   const speechParamsSync = {
  //     OutputFormat: "mp3",
  //     Text: text,
  //     Engine: "standard", // to be changed to neural upon public release
  //     VoiceId: "Matthew"
  //   };
  //   try {
  //     let url = await getSynthesizeSpeechUrl({
  //       client, params: speechParamsSync
  //     });
  //     let player = document.getElementById('audioPlayback')
  //     player.style.display = "";
  //     replaceSourceLoadPlay(url)
  //   } catch (err) {
  //     // mettre failure message dans la feedback window
  //   }
  // }

  function replaceSourceLoadPlay(mp3Url) {
    if (document.body.contains(audioSource) && document.body.contains(player)) {
      audioSource.src = mp3Url;
      player.load();
      player.play();
    }
  }

  function playIntroAudio() {
    if (textLengthChar < 1000) {
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/a3f999a0-cacd-4b83-896e-154ee02b1a66.mp3") // announcing about 10 secs
    } else if (textLengthChar < 4500) {
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/f7139878-b1bf-4dd9-83db-92ddfdc5e4c9.mp3") // announcing about 20 secs
    } else if (textLengthChar < 9000) {
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/3ce22452-d73b-45ab-a802-003b974b11a2.mp3") // announcing about 30 secs
    } else if (textLengthChar < 13500) {
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/f0adfeed-1b7c-45af-9b31-ff6f0fd659e9.mp3") // announcing about 40 secs
    } else if (textLengthChar < 18000) {
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/51ba9d62-0f45-43cf-8aca-45e302832ae1.mp3") // announcing about 50 secs
    } else if (textLengthChar < 22500){
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/7a768db5-e04f-41e2-b51b-eb0518df8ebc.mp3") // announcing about one minute
    } else if (textLengthChar < 27000){
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/8141fc7b-fd3c-43ad-b908-5f1d3ff2f3c1.mp3") // announcing about one minute and ten seconds
    } else if (textLengthChar < 31500){
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/f44b379e-3139-431a-8dc4-594122240be3.mp3") // announcing about one minute and twenty seconds
    } else if (textLengthChar < 36000) {
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/9308f52c-69ae-442c-9e32-3c379927b23b.mp3") // announcing about one minute and a half
    } else if (textLengthChar < 49500) {
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/3a3b537f-afbf-4648-a74a-56cd749cd2b1.mp3") // announcing about 2 minutes
    } else if (textLengthChar < 75000){
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/e7cedfa3-e13d-44b1-b73b-1296f72802a3.mp3") // announcing about 3 minutes
    } else if (textLengthChar < 100000){
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/ae716528-e10c-424e-9a81-fb77ec521bb2.mp3") // announcing about 4 minutes
    } else {
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/93132d9b-f936-4c61-9330-fcc0ef4493c9.mp3") // announcing more than 4 minutes
    }
  }

  const longText = async() => {
    const speechParamsAsync = {
      OutputS3BucketName: "polly-async",
      OutputFormat: "mp3",
      Text: text,
      Engine: "neural",
      VoiceId: "Matthew",
    };
    try {
      let firstValue = await client.send(
        new StartSpeechSynthesisTaskCommand(speechParamsAsync)
      );
      player.style.display = "";
      playIntroAudio()
      console.log(firstValue);
      let taskId = firstValue.SynthesisTask.TaskId;
      console.log(taskId)
      let outputUri = firstValue.SynthesisTask.OutputUri;
      console.log(outputUri)
      let progressSeconds = 0
      const interval = setInterval(async () => {
        let secondValue = await client.send(
          new GetSpeechSynthesisTaskCommand({TaskId: taskId})
        )
        let pollingResponse = secondValue.SynthesisTask.TaskStatus
        console.log(pollingResponse)
        if (pollingResponse == "inProgress") {
          console.log(progressSeconds)
          progressSeconds++;
          if (progressSeconds == 10) {
            if (textLengthChar < 9000) {
              // si annonce 30 secs, dire qu'il reste 10 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/efb3d660-00dc-483a-bf29-5f315c06ea62.mp3");
            } else if (textLengthChar < 13500) {
              // si annonce 40 secs, dire qu'il reste 20 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/5ae85867-770b-4d2f-9144-e86154aaddd0.mp3");
            } else if (textLengthChar < 18000) {
              // si annonce 50 secs, dire qu'il reste 30 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/8f5faa34-688c-43f9-8d89-ad83bb54c56f.mp3");
            } else if (textLengthChar < 22500) {
              // si annonce une minute, dire qu'il reste 40 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/cc38b26c-88d6-4694-b837-834c99490180.mp3");
            } else if (textLengthChar < 27000) {
              // si annonce 1min10, dire qu'il reste 50 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/5a561b11-56a8-4da4-a9d7-819243fe3675.mp3");
            } else if (textLengthChar < 31500) {
              // si annonce 1min20, dire qu'il reste une min
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/928bdb44-3359-4c99-9b4d-03a55cdf9870.mp3");
            }
          } else if (progressSeconds == 20){
            if (textLengthChar < 13500) {
              // si annonce 40 secs, dire qu'il reste 10 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/efb3d660-00dc-483a-bf29-5f315c06ea62.mp3");
            } else if (textLengthChar < 18000) {
              // si annonce 50 secs, dire qu'il reste 20 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/5ae85867-770b-4d2f-9144-e86154aaddd0.mp3");
            } else if (textLengthChar < 22500) {
              // si annonce une minute, dire qu'il reste 30 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/8f5faa34-688c-43f9-8d89-ad83bb54c56f.mp3");
            } else if (textLengthChar < 27000) {
              // si annonce 1min10, dire qu'il reste 40 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/cc38b26c-88d6-4694-b837-834c99490180.mp3");
            } else if (textLengthChar < 31500) {
              // si annonce 1min20, dire qu'il reste 50 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/5a561b11-56a8-4da4-a9d7-819243fe3675.mp3");
            }
          } else if (progressSeconds == 30){
            if (textLengthChar < 18000) {
              // si annonce 50 secs, dire qu'il reste 10 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/efb3d660-00dc-483a-bf29-5f315c06ea62.mp3");
            } else if (textLengthChar < 22500) {
              // si annonce une minute, dire qu'il reste 20 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/5ae85867-770b-4d2f-9144-e86154aaddd0.mp3");
            } else if (textLengthChar < 27000) {
              // si annonce 1min10, dire qu'il reste 30 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/8f5faa34-688c-43f9-8d89-ad83bb54c56f.mp3");
            } else if (textLengthChar < 31500) {
              // si annonce 1min20, dire qu'il reste 40 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/cc38b26c-88d6-4694-b837-834c99490180.mp3");
            }
          } else if (progressSeconds == 40){
            if (textLengthChar < 22500) {
              // si annonce une minute, dire qu'il reste 10 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/efb3d660-00dc-483a-bf29-5f315c06ea62.mp3");
            } else if (textLengthChar < 27000) {
              // si annonce 1min10, dire qu'il reste 20 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/5ae85867-770b-4d2f-9144-e86154aaddd0.mp3");
            } else if (textLengthChar < 31500) {
              // si annonce 1min20, dire qu'il reste 30 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/8f5faa34-688c-43f9-8d89-ad83bb54c56f.mp3");
            }
          } else if (progressSeconds == 50){
            if (textLengthChar < 27000) {
              // si annonce 1min10, dire qu'il reste 10 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/efb3d660-00dc-483a-bf29-5f315c06ea62.mp3");
            } else if (textLengthChar < 31500) {
              // si annonce 1min20, dire qu'il reste 20 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/5ae85867-770b-4d2f-9144-e86154aaddd0.mp3");
            }
          } else if (progressSeconds == 60){
            if (textLengthChar < 31500) {
              // si annonce 1min20, dire qu'il reste 10 secs
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/efb3d660-00dc-483a-bf29-5f315c06ea62.mp3");
            }
          }
        } else if (pollingResponse == "completed") {
          clearInterval(interval);
          console.log(secondValue);
          replaceSourceLoadPlay(outputUri);
          Rails.ajax({
            url: "/items/persist_mp3_url",
            type: 'POST',
            data: `mp3_url=${outputUri}&id=${itemId}`,
            success: function(data) {
              console.log(data);
            }
          });
          player.addEventListener("loadeddata", function() {
            let textLengthMinActual = this.duration / 60;
            Rails.ajax({
              url: "/application/update_balance_final",
              type: 'POST',
              data: `actual_minutes=${textLengthMinActual}&approx_minutes=${textLengthMinApprox}`,
              success: function(data) {
                console.log(data);
              }
            });
          });
        } else if (pollingResponse == "failed") {
          replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/2aa802f2-69fd-4976-a68d-386323ab4a1a.mp3")
        }
      }, 1000);
    } catch (e) {
      console.log(e)
      player.style.display = "";
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/2aa802f2-69fd-4976-a68d-386323ab4a1a.mp3")
    }
  };

  if (document.body.contains(listenBtn)) {
    listenBtn.addEventListener("click", function() {
      document.getElementById('options').style.display = "none";
      document.getElementById('listen-option').remove()
      if (textLengthChar < 100000) {
        Rails.ajax({
          url: "/application/user_balance",
          type: 'GET',
          data: "",
          success: function(data) {
            let userTtsBalanceInMin = data.balance
            console.log(userTtsBalanceInMin)
            if ((userTtsBalanceInMin !== null) && (userTtsBalanceInMin > textLengthMinApprox + 5)) {
              Rails.ajax({
                url: "/application/update_balance_temp",
                type: 'POST',
                data: `approx_minutes=${textLengthMinApprox}`,
                success: function(data) {
                  console.log(data);
                }
              });
              longText()
            } else if (userTtsBalanceInMin == null) { // i.e. @user.tts_balance_in_min = nil
              player.style.display = "";
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/770aa492-6129-43d8-8f32-2f7db266a7e4.mp3")
            } else {
              player.style.display = "";
              replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/06ffe404-db51-45e1-8474-615cfb748579.mp3")
            }
          }
        });
      } else {
        player.style.display = "";
        replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/2aa802f2-69fd-4976-a68d-386323ab4a1a.mp3")
      }
    });
  }
};

export { textToSpeech };
