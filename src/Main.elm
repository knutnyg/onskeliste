module Main exposing (Model, Msg(..), Wish, WishModel, expandedView, init, main, toModel, update, view, wishView, wishlist)

import Browser
import Html exposing (Html, a, button, div, h1, h2, img, li, span, text, ul)
import Html.Attributes exposing (class, classList, height, href, src, width)
import Html.Events exposing (onClick)


wishlist =
    [ { title = "Koffert \u{1F9F3}"
      , desc = Just "Australiakofferten fra 2005 har sett bedre dager. Det er kansje på tide å gå for noe mer moderne"
      , imgUrl = Just "/suitcase.jpg"
      , link = Nothing
      }
    , { title = "En matopplevelse"
      , desc = Just "Jeg ønsker meg en matopplevelse jeg kan ta med Victoria på 😻"
      , imgUrl = Just "/dinner.jpg"
      , link = Just "https://restaurantguiden.aftenposten.no"
      }
    , { title = "Tufte pysj"
      , desc = Just "Såååå myk 🐨"
      , imgUrl = Just "/pysj.jpg"
      , link = Just "https://tuftewear.no/products/tufte-mens-pyjamas?variant=34150859178115"
      }
    , { title = "Skåler"
      , desc = Just "Litt moderne freshe skåler til f.eks suppe"
      , imgUrl = Just "/skåler.jpg"
      , link = Just "https://www.nordicnest.no/merkevarer/iittala/teema-skal-15-cm/?variantId=16228-01&currency=NOK&countryCode=NO&utm_source=google&utm_medium=surfaces&gclid=CjwKCAiA_Kz-BRAJEiwAhJNY79oIgW-12608zHyBg53ngF4kV2ZMfZwkwSyfeExfdKzfWCBhYmqXkBoCC1UQAvD_BwE"
      }
    , { title = "Apple Watch 5 Cellular \u{1F911}"
      , desc = Just "Tror ikke jeg har vært så snill i år, men en vet aldri 🙈"
      , imgUrl = Just "/klokke.jpg"
      , link = Just "https://www.komplett.no/product/1169725/mobiler-klokker/smartklokker/apple-watch-series-6-40mm-4g-blaablaa"
      }

    -- Ullfrættis
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
