module GamePageParser exposing (parseGamePage)

import Html.Parser exposing (runDocument)
import Parser exposing (DeadEnd)
import SamplePage exposing (rawSamplePage)
import Types exposing (NationStatusRow)


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


getTextNodes : List Html.Parser.Node -> List Html.Parser.Node
getTextNodes nodes =
    List.filter
        (\node ->
            case node of
                Html.Parser.Text text ->
                    True

                _ ->
                    False
        )
        nodes


getTextContent : Html.Parser.Node -> Maybe String
getTextContent node =
    case node of
        Html.Parser.Text text ->
            Just text

        _ ->
            Nothing


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


getChildren : Html.Parser.Node -> List Html.Parser.Node
getChildren node =
    case node of
        Html.Parser.Element name attrs children ->
            children

        _ ->
            []


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


findAllElements : (Html.Parser.Node -> Bool) -> List Html.Parser.Node -> List Html.Parser.Node
findAllElements predicate nodes =
    case List.filter predicate nodes of
        [] ->
            List.concatMap
                (\node ->
                    case node of
                        Html.Parser.Element name attrs children ->
                            findAllElements predicate children

                        _ ->
                            []
                )
                nodes

        xs ->
            xs



-- parseTableRow : Html.Parser.Node -> Maybe { name : String, value : String }
-- parseTableRow : Html.Parser.Node -> Maybe { name : String, value : String }


getTextFromTd : Html.Parser.Node -> Maybe String
getTextFromTd =
    getChildren >> List.head >> Maybe.andThen getTextContent


parseTableRow : Html.Parser.Node -> Maybe NationStatusRow
parseTableRow row =
    case row of
        Html.Parser.Element _ _ children ->
            let
                tdCells =
                    findAllElements (tagMatches "td") children
            in
            case tdCells of
                [ nameTdCell, valueTdCell ] ->
                    Just
                        { name =
                            getTextFromTd nameTdCell
                                |> Maybe.withDefault "No nation name"
                        , value =
                            getTextFromTd valueTdCell
                                |> Maybe.withDefault "No value found"
                        }

                _ ->
                    Nothing

        _ ->
            Nothing


{-| parsedGamePage : Result (List DeadEnd) Html.Parser.Document
-}
parseGamePage : String -> Maybe (List NationStatusRow)
parseGamePage rawPage =
    case runDocument rawPage of
        Ok doc ->
            case doc.document of
                ( attrs, nodes ) ->
                    getBodyEl nodes
                        |> findAllElements (tagMatches "table")
                        |> findAllElements (tagMatches "tr")
                        |> List.filterMap parseTableRow
                        |> Just

        Err deadEnds ->
            Nothing
