port module Background exposing (..)

import Json.Decode as D
import Json.Encode as E

main : Program () Model Msg
main =
    Platform.worker 
        { init = init
        , update = update
        , subscriptions = subscriptions
        }

{- Ports -}
port createNotification : E.Value -> Cmd msg
port messageReceiver : (D.Value -> msg) -> Sub msg

type alias NotificationOptions =
    { ntType : String
    , title : String
    , message : String
    , iconUrl : String
    , imageUrl : Maybe String
    }

encodeNotificationOptions : NotificationOptions -> E.Value
encodeNotificationOptions ntOpt =
    E.object
        [ ("type", E.string ntOpt.ntType)
        , ("title", E.string ntOpt.title)
        , ("message", E.string ntOpt.message)
        , ("iconUrl", E.string ntOpt.iconUrl)
        , ("imageUrl",
            case ntOpt.imageUrl of
                Just imageUrl -> E.string imageUrl
                Nothing       -> E.null
          )
        ]

type alias TweetData =
    { has_image : Bool
    , user_name : String
    , body_text : String
    , user_iconUrl : String
    , body_imageUrl : Maybe String
    }

decoderTweetData : D.Decoder TweetData
decoderTweetData =
    D.map5 TweetData
        (D.field "has_image" D.bool)
        (D.field "user_name" D.string)
        (D.field "body_text" D.string)
        (D.field "user_iconUrl" D.string)
        (D.field "body_imageUrl" (D.maybe D.string))

tweetData2notificationOptions : TweetData -> NotificationOptions
tweetData2notificationOptions tweet_data =
    if tweet_data.has_image then
        { ntType = "image"
        , title = tweet_data.user_name
        , message = tweet_data.body_text
        , iconUrl = "./img/test.png"
        , imageUrl = Just "./img/test.png"
        }
    else
        { ntType = "basic"
        , title = tweet_data.user_name
        , message = tweet_data.body_text
        , iconUrl = "./img/test.png"
        , imageUrl = Nothing
        }

{- Model -}
type alias Model = {}

newModel : Model
newModel = {}

init : () -> (Model, Cmd Msg)
init _ =
    (newModel, Cmd.none)

{- Update -}
type Msg 
    = NoOp
    | GotTweetData D.Value

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        {- There is nothing to do. -}
        NoOp ->
            (model, Cmd.none)
        {- When tweet data is received from the content script. -}
        GotTweetData tweet_data_json ->
            case D.decodeValue decoderTweetData tweet_data_json of
                Ok  tweet_data ->
                    let
                        ntOpt = tweetData2notificationOptions tweet_data
                        ntOpt_json = encodeNotificationOptions ntOpt
                    in
                    (model, createNotification ntOpt_json)
                Err err ->
                    Debug.log (D.errorToString err) (model, Cmd.none)

{- Subscriptions -}
subscriptions : Model -> Sub Msg
subscriptions _ =
    messageReceiver GotTweetData
