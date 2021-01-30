// Initialize the Background.elm.
let app = Elm.Background.init();

// Port: Create the notification.
app.ports.createNotification.subscribe((opt) => {
    chrome.notifications.create(opt, (id) => {});
});

// Port: Pass through the message to the Background.elm.
chrome.runtime.onMessage.addListener((msg) => {
    console.log("recieve:", msg);
    app.ports.messageReceiver.send(msg);
});
