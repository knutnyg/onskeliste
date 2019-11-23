module Main exposing (..)

import Browser
import Html exposing (Html, a, button, div, h1, h2, img, li, text, ul)
import Html.Attributes exposing (class, classList, height, href, src, width)
import Html.Events exposing (onClick)



---- MODEL ----


type alias Wish =
    { id : Int
    , title : String
    , desc : Maybe String
    , imgUrl : Maybe String
    , expanded : Bool
    , link : Maybe String
    }


type alias Model =
    { wishes : List Wish }



wishlist =
    [ { id = 1
      , title = "Batteridrevet blåtannhøytaler"
      , desc = Just "En bra en"
      , imgUrl = Just "https://www.komplett.no/img/p/1200/1132400.jpg"
      , expanded = False
      , link = Nothing
      }
    , { id = 2
      , title = "Ullsokker"
      , desc = Just "Både halvtykke tursokker, og det er kaldt på kontoret hverdagssokker"
      , imgUrl = Nothing
      , expanded = False
      , link = Nothing
      }, { id = 3
      , title = "Fin hverdagssekk"
      , desc = Just "Jeg ønsker meg en litt finere ryggsekk til hverdagen. Gjerne litt stiligere enn en vanlig skolesekk. Jeg har typisk med meg en liten laptop, trengingstøy og sykler i all slags vær"
      , imgUrl = Nothing
      , expanded = False
      , link = Nothing
      }, { id = 4
      , title = "Treningsbukse"
      , desc = Just "En til å løpe i. Gjerne litt tettsittende men ikke thights og ikke i sånn tykk bommul. Størrelse M (41/42)"
      , imgUrl = Nothing
      , expanded = False
      , link = Nothing
      }, { id = 5
      , title = "Trenings skjorte langermet"
      , desc = Just "Litt varmere / solid skjorte til å løpe ute med når det blir litt kaldere. Bra med refleks, lomme til mobil og nøkler"
      , imgUrl = Nothing
      , expanded = False
      , link = Nothing
      }, { id = 6
      , title = "The Unicorn project"
      , desc = Just "En bok som handler om prosjekter"
      , imgUrl = Nothing
      , expanded = False
      , link = Nothing
      }, { id = 7
      , title = "Hengekøye gjerne m/myggnetting"
      , desc = Just "I 2020 skal jeg sove ute minst 5 ganger. Ticket to the Moon er et kjent alternativ"
      , imgUrl = Nothing
      , expanded = False
      , link = Nothing
      }, { id = 8
      , title = "Vindusvaskerobot 🤖"
      , desc = Just "Hvorfor gjøre noe selv når det kan automatiseres? Ecovacs Winbot får bra kritikk men er svindyr 💸"
      , imgUrl = Nothing
      , expanded = False
      , link = Nothing
      }, { id = 9
      , title = "Koffert 🧳"
      , desc = Just "Australiakofferten fra 2005 har sett bedre dager. Det er kansje på tide å gå for noe mer moderne"
      , imgUrl = Just "/suitcase.jpg"
      , expanded = False
      , link = Nothing
      }
    ]

init : ( Model, Cmd Msg )
init =
    ( Model wishlist, Cmd.none )



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


wishView : Wish -> Html Msg
wishView wish =
    li []
        [ div [ class "wish-header" ]
            [ h2 [] [ text wish.title ]
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


expandedView : Wish -> Html Msg
expandedView wish =
    div
        [ class
            (if wish.expanded then
                "expanded"

             else
                "hidden"
            )
        ]
        [ case wish.desc of
            Nothing ->
                text "missing"

            Just desc ->
                text desc
        , case wish.imgUrl of
            Nothing ->
                text ""

            Just url ->
                img [ src url, class "teaser" ] []
        , case wish.link of
            Nothing ->
                text ""

            Just url ->
                a [ href url ] [ text "eksempel"]
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
