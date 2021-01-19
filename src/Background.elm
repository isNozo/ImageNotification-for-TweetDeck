module Background exposing (..)

main : Program () Model Msg
main =
    Platform.worker 
        { init = init
        , update = update
        , subscriptions = subscriptions
        }

type alias Model = {}
type Msg = NoOp

init : () -> (Model, Cmd Msg)
init _ = Debug.log "Background.elm is inited." ({}, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = ({}, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none
