module Components.TopicChooser exposing (..)

import List exposing (..)
import Dict exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )

import Topic exposing (..)

-- TopicChooser Model
-- -- we don't need a model, just need a view that takes inputs

-- TopicChooser Msg
type Msg
  = ChangeTopic String

-- TopicChooser View
topicchooser : List String -> Dict String Topic.Model -> Html Msg
topicchooser mainTopics topics =
  div [ class "container" ]
    -- map each maintopic... recurse
    (List.map (topicSquare topics 0) mainTopics)


topicSquare : Dict String Topic.Model -> Int -> String -> Html Msg
topicSquare topics level key =
  case Dict.get key topics of
    Just topic ->
      let
        padding =
          case level of
            0 -> "20px"
            1 -> "5px"
            _ -> "2px"
      in
        div [ style [("display","flex"),("width","100%"),("margin",padding)] ]
          -- render the button for this topic
          (
            button [ style [("border","1px solid"),("min-width","200px")], onClick (ChangeTopic key) ][
              text topic.name
            ] :: List.map (topicSquare topics (level+1)) topic.children
          )

    Nothing ->
      text ""

{-
  How do you view a nested list of things?
  I commonly see things like

  Group 1
   - Item 1
   - Item 2
  Group 2
    - SubGroup 1
      - Item 1
      - Item 2
    - SubGroup 2
     - Item 1

  Bulma has a 'menu' component like this
  http://bulma.io/documentation/components/menu/

  is that really the only way to view a nested list of things?
  examples
  http://semantic-ui.com/elements/list.html
  https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLiB2PY5HxyO9-dJlO0UXopw68U5V3gN0_KR5kVkrpj7-djfZNRw

  maybe we shouldn't even try to shove this all into a normal list
  maybe make a nice full-page UI instead.
  http://ux.stackexchange.com/questions/18991/is-there-any-alternative-ui-for-tree-structure

  **** DuoLingo has a great system for this... blatantly rip it off?

  Rosetta Stone doesn't even tell you what the topics are (right away).
  Instead, it breaks down topics into non-descript "Levels"
  http://www.rosettastone.com/image/image_gallery?uuid=6972ecb8-c850-4a9a-b45c-965ec3c4a487&groupId=10165&t=1428700114491

  I guess what I like is..

  Group 1
    Item1  Item2  Item3
  Group 2
    Item1  Item2

  but what about subsubtopics?

  Group1
    Item1  Item2       Item3
             SubItem1
             SubItem2
  Group2
    Item1      Item2    Item3
      SubItem1            SubItem1


  God have mercy on us if we got further than 2 subtopics
  Need to consistently space buttons apart.  Maybe assume 10 character limit?
  Characters = 9 characters

  That's kind of getting out of hand...

  I also kind of like the square "Arrays" on that stack exchange site
  ********* LET'S TRY IT!!!! *********
  (using bulma tiles, http://bulma.io/documentation/grid/tiles/ )

-}
