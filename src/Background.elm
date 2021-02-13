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
port createNotif : E.Value -> Cmd msg
port messageReceiver : (D.Value -> msg) -> Sub msg

type NotifType = Basic | Image
type alias NotifOptions =
    { notifType : NotifType
    , title : String
    , message : String
    , iconUrl : String
    , imageUrl : Maybe String
    }

encodeNotifOptions : NotifOptions -> E.Value
encodeNotifOptions opt =
    E.object
        [ ("type",
            case opt.notifType of
                Basic -> E.string "basic"
                Image -> E.string "image"
          )
        , ("title", E.string opt.title)
        , ("message", E.string opt.message)
        , ("iconUrl", E.string opt.iconUrl)
        , ("imageUrl",
            case opt.imageUrl of
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

tweetData2NotifOptions : TweetData -> NotifOptions
tweetData2NotifOptions tweetData =
    if tweetData.has_image then
        { notifType = Image
        , title = tweetData.user_name
        , message = tweetData.body_text
        , iconUrl = "./img/test.png"
        , imageUrl = Just "./img/test.png"
        }
    else
        { notifType = Basic
        , title = tweetData.user_name
        , message = tweetData.body_text
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
        GotTweetData tweetDataJson ->
            case D.decodeValue decoderTweetData tweetDataJson of
                Ok  tweetData ->
                    let
                        cmd = tweetData
                            |> tweetData2NotifOptions
                            |> encodeNotifOptions
                            |> createNotif
                    in
                    (model, cmd)
                Err err ->
                    Debug.log (D.errorToString err) (model, Cmd.none)

{- Subscriptions -}
subscriptions : Model -> Sub Msg
subscriptions _ =
    messageReceiver GotTweetData
