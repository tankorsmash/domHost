module GamePageParser exposing (parsedGamePage)

import Html.Parser exposing (runDocument)
import Parser exposing (DeadEnd)
import SamplePage exposing (rawSamplePage)


isElement : Html.Parser.Node -> Bool
isElement node =
    case node of
        Html.Parser.Element name attrs children ->
            True

        _ ->
            False


mapElementMaybe : (Html.Parser.Node -> a) -> Html.Parser.Node -> Maybe a
mapElementMaybe mapFunc node =
    case node of
        Html.Parser.Element name attrs children ->
            Just (mapFunc node)

        _ ->
            Nothing


mapElement : (Html.Parser.Node -> Html.Parser.Node) -> Html.Parser.Node -> Html.Parser.Node
mapElement mapFunc node =
    case node of
        Html.Parser.Element name attrs children ->
            mapFunc node

        _ ->
            node


getElements : List Html.Parser.Node -> List Html.Parser.Node
getElements =
    List.filter isElement


tagMatches : String -> Html.Parser.Node -> Bool
tagMatches tagName node =
    case node of
        Html.Parser.Element name attrs children ->
            name == tagName

        _ ->
            False


getBodyEl : List Html.Parser.Node -> List Html.Parser.Node
getBodyEl bodyNodes =
    List.filter
        (tagMatches "body")
        bodyNodes


findFirstElement : (Html.Parser.Node -> Bool) -> List Html.Parser.Node -> Maybe Html.Parser.Node
findFirstElement predicate nodes =
    case List.filter predicate nodes of
        [] ->
            List.filterMap
                (\node ->
                    case node of
                        Html.Parser.Element name attrs children ->
                            findFirstElement predicate children

                        _ ->
                            Nothing
                )
                nodes
                |> List.head

        x :: xs ->
            Just x


{-| parsedGamePage : Result (List DeadEnd) Html.Parser.Document
-}
parsedGamePage =
    case runDocument rawSamplePage of
        Ok doc ->
            case doc.document of
                ( attrs, nodes ) ->
                    getBodyEl nodes
                        |> findFirstElement (tagMatches "table")

        Err deadEnds ->
            Nothing
