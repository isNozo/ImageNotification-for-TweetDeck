// Initialize the Background.elm program
let app = Elm.Background.init();

/* 
 * Port functions
 */
app.ports.createNotification.subscribe((data) => {
    console.log(new Date(), data);

    let opt = {
        type : undefined,
        title : data.title,
        message : data.message,
        iconUrl : data.iconUrl,
        imageUrl : undefined
    };

    if (data.ntType == "basic") {
        opt.type = "basic";
    } else if (data.ntType == "image") {
        opt.type = "image";
        opt.imageUrl = data.imageUrl;
    } else {
        console.error("Notification type is invalid.");
        return;
    };

    chrome.notifications.create(opt, (id) => {});
});
