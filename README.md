# backgammon

A mini hackathon style project used as a tech test.

### Brief

Write a simple game of your choice, using Flutter and Flame, with a hidden method to access a webview which deeplinks to a URL. Method to reveal the hidden webview can be a series of taps on a specific part of the app or any other method that should not be discovered by accident.

## Introduction

I chose to recreate Backgammon in Flame, as it involves various game states. Resources used for game rules:

- [WikiHow youtube channel - How to Play Backgammon](https://alb-pixel-store.itch.io/classic-board-games-assets)
- [Backgammon Galore! website - How to Play](https://www.bkgm.com/rules.html)

I also used a [Classic Board Games](https://alb-pixel-store.itch.io/classic-board-games-assets) asset pack for the sprites.

Disclaimer: please note, this is the first time I've used Flame and so the majority of the time was spent learning it. I feel like I've made pretty good progress and done some justice to the brief but also like I've only scratched the surface of Flame's feature set and best practise. Theres more I'd like to include and some state management improvements I'd like to make given more time.


## How to Play

The game starts with the pieces laid out as they should be for Backgammon with a "player" and "opponent". The player is set to move first. The aim of the game is to get all your pieces into the win pile (the blue section to the right). The player must move anti-clockwise around the board, from point to point, and the opponent must move clockwise. You cannot move onto a point that has two or more opposing pieces. 

To move hold and release the dice in the middle of the screen. Once done you should see a pair of dice appear in the side section to the right, these are your available moves. You can move one piece along the board to the total number on both die, or you can move two pieces on the board using one die each.

Once you've used both die then its the other players turn. If don't have any available moves then press the "End turn" button.

If you move onto a point that has only one opposing piece then that is sent to the bar (the middle section of the board). If either player has piece(s) in the bar then they must get those back on the board first, by rolling and using a die to move then into their starting area. The starting area for the player is the top right quadrant and for the opponent its the bottom left.

**All the rules can be found in app by opening the side menu via the burger icon on the right hand side.**

## Secret Method

<details>
  <summary>Secret Method revealed here</summary>
  
  1. Roll the dice at least once
  1. Tap the top left corner of the screen the number of times shown on the lower numbered die
  1. Tap the bottom right corner of the screen the number of times on the higher numbered die
</details>

## Webview Deeplinking

I wasn't entirely sure what was meant by "a webview which deeplinks to a URL" but I have taken it to mean:

- Open a webview in app to a specific website (I chose google.com)
- On that website there should be a link to a product that has a mobile app the user has on their phone (e.g. YouTube, whatsapp, etc)
- Tapping that link shouldn't open it inside the webview, but should instead take the user to the app version of the product they have installed on their device

Yhe app I chose to deeplink to was YouTube, sorry about the video choice it was all I could think of. A link to YouTuve can be found on google.com by tapping the "more apps" icon in the top right. (The icon is a 9x9 grid of boxes.) 

- On iOS this opens up a context menu with a youtube app link.
- On Android - Google Pixel 5 - I found this opens a long marketing page, however the youtube link can be found towards the bottom.

## Architecture and State Management

Since this project is only a test I took a relaxed approach to architecture, moving things around when it felt necessary and focussing instead on the build. I have ended up grouping all the game code into one directory and the other code in logical groups. I would consider moving things into separate packages for a longer project (e.g. game and mobile).

I used `flutter_riverpod` with `flame_riverpod` to control the "main game state" (who's turn it is and what the current die values are) in the game code and to expose it to the main app. The non "main game state" - values and events the main app doesn't care about like what piece is positioned at which point and which piece can move where (see `Piece.onDragEnd`) - are handled mostly inline directly in the game code to speed developement. Given more time I would probably continue with `flame_riverpod` and abstract the logic into one or many state providers.

I also used the `url_launcher` class directly inside `WebviewScreen`. Under normal circumstances I would create a wrapper service class in case the plugin needed to change.

## Localisation

Since this is just a mini project I didn't do any scaffolding around multi language support and just hard coded the copy directly in the relevant widgets. This is very bad practise I know, due to how long the game took to build I ran out of time.

## Testing

This is definitely where the project is lacking the most, I didn't use a TDD approach or add tests after each step because I wanted to learn Flame fast and produce a complete as can be game. In order to test Flame code I would have had to learn its testing suite, which would have taken too long.

## Platform Support

I removed any boilerplate/config for MacOS, Windows, Linux and Web because I haven't tested the webview functionality. The main backgammon game would run on all 4 though so they can easily be added back in, in order to showcase the test.

## Extra game functionality 

I'd like to add a lot of extra game functionality, and also fix a bugs that I spotted doing a final sweep:

- Ability for player to change piece color
  - This wouldn't take long now the sprite config is set up we would need to remove the color from the `Player` enum though and store it in a state object, likely `BackgammonState` along side `currentPlayer`.
- Add a win screen and game reset option
  - Right now nothing happens when the player gets all their pieces into the win pile
- Finish implementing the rules
  - If you read the backgammon rules (links above) you can see I've skipped out a few rules. The biggest is allowing 4 turns when the player rolls a double. Now the main game state is all set up, I don't think this would take long.
- AI so the game can be one player instead of pass and play
- Unit and Widget Tests
- End to end tests with Patrol
  - I had a lofty plan of implementing a "Fuzzy tester" which would attempt to go through the game choosing moves at random. This would be great at uncovering bugs this is very far off.

