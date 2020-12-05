module Main exposing (..)

import Browser
import Html exposing (Html, a, button, div, h1, h2, img, li, span, text, ul)
import Html.Attributes exposing (class, classList, height, href, src, width)
import Html.Events exposing (onClick)


wishlist =
    [{ title = "Koffert \u{1F9F3}"
      , desc = Just "Australiakofferten fra 2005 har sett bedre dager. Det er kansje på tide å gå for noe mer moderne"
      , imgUrl = Just "/suitcase.jpg"
      , link = Nothing
      }
    ]



---- MODEL ----


type alias Wish =
    { title : String
    , desc : Maybe String
    , imgUrl : Maybe String
    , link : Maybe String
    }


type alias WishModel =
    { wish : Wish
    , id : Int
    , expanded : Bool
    }


type alias Model =
    { wishes : List WishModel }


init : ( Model, Cmd Msg )
init =
    ( Model (toModel wishlist), Cmd.none )


toModel : List Wish -> List WishModel
toModel list =
    List.indexedMap (\i wish -> WishModel wish i False) list



---- UPDATE ----


type Msg
    = Flip Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Flip id ->
            let
                flip wish =
                    if wish.id == id then
                        { wish | expanded = not wish.expanded }

                    else
                        wish

                wishes =
                    List.map flip model.wishes
            in
            ( { model | wishes = wishes }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ img [ src "/santa.jpg", class "santa" ] []
        , h1 [] [ text "Knuts ønskeliste i Elm" ]
        , div []
            [ ul []
                (List.map (\wish -> wishView wish) model.wishes)
            ]
        ]


wishView : WishModel -> Html Msg
wishView wish =
    li []
        [ div [ class "wish-header" ]
            [ h2 [] [ text wish.wish.title ]
            , button [ onClick (Flip wish.id) ]
                [ text
                    (if wish.expanded then
                        "-"

                     else
                        "+"
                    )
                ]
            ]
        , expandedView wish
        ]


expandedView : WishModel -> Html Msg
expandedView wish =
    div
        [ class
            (if wish.expanded then
                "expanded"

             else
                "hidden"
            )
        ]
        [ div [ class "exp-text" ]
            [ case wish.wish.desc of
                Nothing ->
                    text "missing"

                Just desc ->
                    span [] [ text desc ]
            , case wish.wish.link of
                Nothing ->
                    text ""

                Just url ->
                    a [ href url ] [ text "eksempel" ]
            ]
        , case wish.wish.imgUrl of
            Nothing ->
                text ""

            Just url ->
                img [ src url, class "teaser" ] []
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
