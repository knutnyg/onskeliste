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
      , desc = Just "En solid og bra en til å ta med seg rundt omkring."
      , imgUrl = Just "https://www.komplett.no/img/p/1200/1132400.jpg"
      , expanded = False
      , link = Just "https://www.komplett.no/product/1132400/tv-lyd-bilde/hoeyttalere/multiroom/ultimate-ears-wonderboom-2-hoeyttaler"
      }
    , { id = 2
      , title = "Ullsokker"
      , desc = Just "Halvtykke strikka ullsokker, mer tettsittende tursokker og hverdagssokker"
      , imgUrl = Just "https://dm9fd9qvy1kqy.cloudfront.net/media/catalog/product/cache/3/image/500x/17f82f742ffe127f42dca9de82fb58b1/7/5/x75103-11201_DetailImage2.jpg.pagespeed.ic.KBzhkGGS14.jpg"
      , expanded = False
      , link = Just "https://www.fjellsport.no/ulvang-allround-3pk-grey-melange-charcoal-melange.html?channable=e80712.MTA5LTI4MTA&gclid=CjwKCAiAzuPuBRAIEiwAkkmOSHLzWSalscgkHiliffYdPCQ7vpzmhifSnNwZGWiPGedwVamBieHT8hoCiSsQAvD_BwE"
      }, { id = 3
      , title = "Fin hverdagssekk"
      , desc = Just "Jeg ønsker meg en litt finere ryggsekk til hverdagen. Gjerne litt stiligere enn en vanlig skolesekk. Jeg har typisk med meg en liten laptop, trengingstøy og sykler i alt slags vær"
      , imgUrl = Nothing
      , expanded = False
      , link = Nothing
      }, { id = 4
      , title = "Treningsbukse"
      , desc = Just "En til å løpe i. Gjerne litt tettsittende men ikke thights og ikke i sånn tykk bommul. Størrelse M (41/42)"
      , imgUrl = Just "/treningsbukse.jpeg"
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
      , link = Just "https://www.amazon.com/Unicorn-Project-Developers-Disruption-Thriving-ebook/dp/B07QT9QR41"
      }, { id = 7
      , title = "Hengekøye m/myggnetting"
      , desc = Just "I 2020 skal jeg sove ute minst 5 ganger. Ticket to the Moon er et kjent alternativ"
      , imgUrl = Just "https://thumbs.nosto.com/quick/waj8jbwd/1/713176/8ca3abb90cec4b20a487491e372a79f71ec5df53ef61fb2538aca4a7b3a92977a/A"
      , expanded = False
      , link = Just "https://www.fjellsport.no/ticket-to-the-moon-original-hammock-pakke.html?q=ticket%20to%20the%20moon"
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
