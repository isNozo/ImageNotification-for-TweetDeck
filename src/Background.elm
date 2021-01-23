port module Background exposing (..)

main : Program () Model Msg
main =
    Platform.worker 
        { init = init
        , update = update
        , subscriptions = subscriptions
        }

type alias Model = {}
type Msg = NoOp

port createNotification : NotificationOptions -> Cmd msg

type alias NotificationOptions =
    { ntType : String
    , title : String
    , message : String
    , iconUrl : String
    , imageUrl : Maybe String
    }

testNotificationOptions : NotificationOptions
testNotificationOptions =
    { ntType = "image"
    , title = "test title"
    , message = "test message"
    , iconUrl = "img/test.png"
    , imageUrl = Just "img/test.png"
    }

init : () -> (Model, Cmd Msg)
init _ = 
    ({}, createNotification testNotificationOptions)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = ({}, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none
