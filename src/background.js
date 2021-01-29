// Initialize the Background.elm program
let app = Elm.Background.init();

// Create a notification using a data received from the Elm program.
app.ports.createNotification.subscribe((data) => {
    let opt = {
        type : data.ntType,
        title : data.title,
        message : data.message,
        iconUrl : data.iconUrl,
        imageUrl : data.imageUrl
    };

    chrome.notifications.create(opt, (id) => {});
});

// Receive the message from the content.js.
chrome.runtime.onMessage.addListener((msg) => {
    console.log("recieve:", msg);

    let opt = {
        nTtype : "basic",
        title : msg.title,
        message : msg.message,
        iconUrl : "./img/test.png",
        imageUrl : null
    }

    app.ports.messageReceiver.send(opt);
});
