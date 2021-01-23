port module Background exposing (..)

main : Program () Model Msg
main =
    Platform.worker 
        { init = init
        , update = update
        , subscriptions = subscriptions
        }

{- Ports -}
port createNotification : NotificationOptions -> Cmd msg

type alias NotificationOptions =
    { ntType : String
    , title : String
    , message : String
    , iconUrl : String
    , imageUrl : Maybe String
    }

{- Model -}
type alias Model = {}

newModel : Model
newModel = {}

init : () -> (Model, Cmd Msg)
init _ =  (newModel, Cmd.none)

{- Update -}
type Msg 
    = NoOp
    | GetNotofication NotificationOptions

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        {- There is nothing to do. -}
        NoOp ->
            (model, Cmd.none)
        {- When a notification item is received from the contents script. -}
        GetNotofication ntOpt ->
            (model, createNotification ntOpt)

{- Subscriptions -}
subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none
