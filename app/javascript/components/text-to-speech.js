const synthesizeText = () => {

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

  var synthesizeBtn = document.querySelector("#synthesize")

  let text = document.getElementById("txt-area").value;

  const shortText = async() => {
    const speechParamsSync = {
      OutputFormat: "mp3",
      Text: text,
      VoiceId: "Matthew"
    };
    try {
      let url = await getSynthesizeSpeechUrl({
        client, params: speechParamsSync
      });
      document.getElementById('audioSource').src = url;
      document.getElementById('audioPlayback').load();
    } catch (err) {
      synthesizeBtn.innerHTML = err;
    }
  }

  const delay = ms => new Promise(res => setTimeout(res, ms));

  const longText = async() => {
    const speechParamsAsync = {
      OutputS3BucketName: "polly-async",
      OutputFormat: "mp3",
      Text: text,
      VoiceId: "Matthew"
    };
    let firstValue = await client.send(
      new StartSpeechSynthesisTaskCommand(speechParamsAsync)
    );
    console.log(firstValue);
    let taskId = firstValue.SynthesisTask.TaskId;
    console.log(taskId)
    let outputUri = firstValue.SynthesisTask.OutputUri;
    console.log(outputUri)
    synthesizeBtn.innerHTML = "wait";
    await delay(20000);
    let secondValue = await client.send(
      new GetSpeechSynthesisTaskCommand({TaskId: taskId})
    );
    console.log(secondValue);
    document.getElementById('audioSource').src = outputUri;
    document.getElementById('audioPlayback').load();
    synthesizeBtn.innerHTML = "readyyy";
  };

  function speakText() {
    if (text.length > 3000) {
      shortText()
    } else {
      longText()
    }
  };

  synthesizeBtn.addEventListener('click', speakText);
}

export { synthesizeText };
