module User exposing (..)

-- User Model
type alias Model =
  {
    id: String,
    name: String,
    email: String,
    is_admin: Bool
  }

type alias UserMessageModel =
  {
    id: String,
    name: Maybe String,
    email: Maybe String,
    password: Maybe String,
    new_password: Maybe String
  }

-- User Msg
type Msg
  = UpdateMsg UserMessageModel

-- User Update
update : Msg -> Model -> Model
update msg model =
    case msg of
      UpdateMsg submsg ->
        if submsg.id == model.id then
          case submsg.name of
            Just name ->
              { model | name = name }
            Nothing ->
              model
        else
          model
