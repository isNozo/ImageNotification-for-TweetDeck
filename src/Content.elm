module Content exposing (..)

main : Program () Model Msg
main =
    Platform.worker 
        { init = init
        , update = update
        , subscriptions = subscriptions
        }

{- Model -}
type alias Model = {}

newModel : Model
newModel = {}

init : () -> (Model, Cmd Msg)
init _ = 
    Debug.log "Content.elm is inited" (newModel, Cmd.none)

{- Update -}
type Msg 
    = NoOp

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        {- There is nothing to do. -}
        NoOp ->
            (model, Cmd.none)

{- Subscriptions -}
subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none
