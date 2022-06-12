# Tic-Tac-Toe

## General game concept

The [Wikipedia](https://en.wikipedia.org/wiki/Tic-tac-toe) article sums up the game like this:

Tic-tac-toe is played on a three-by-three grid by two players, who alternately place the marks X and O in one of the nine spaces in the grid.

The player who succeeds in placing three of their marks in a horizontal, vertical, or diagonal row is the winner.

## How it works for this server

In order to play a game of Tic-Tac-Toe a `Game` has to be created by a client.

The client that creates a new game will always be `Player X`.

To start playing, another client has to join the game.

The client that joins the game will always be `Player O`.

The system randomly chooses who is allowed to move first.

If it's the player's turn, the active player then can send a `move` to the server, marking a free field on the game board.

If it's the other player's turn, the inactive player needs to watch/poll the game state of the server to fetch the last move of the other player and switch into the active player role after that.

The server will determine if one of the players has won the game or the game ended in a draw.

---

# Resources

## The `Game` object

The `Game` object is the response of all successful calls to the endpoints and projects the state of a game for the authenticated player.

### Example

```
{
  "name": "towering-pot-1025",
  "state": "your_turn",
  "board": ["f", "f", "f", "f", "f", "f", "f", "f", "f"],
  "player_token": "SejhTFP87yTzRogX1vnYiEvq",
  "player_role": "x",
  "next_move_token": "Zw6xpZzV9yeasuaMg7q69X49",
  "created_at": "2022-06-11T19:57:47.083Z",
  "updated_at": "2022-06-11T19:57:47.083Z"
}
```

### Attributes

#### `name` (String)

The name of the game is randomly generated when a new game is created.

It must be used by the second player to join the game.


#### `state` (String)

Hello world, this is a blind text.

- `awaiting_join` Bla bla bal fs
- `your_turn` Bla bla bal fs
- `their_turn` Bla bla bal fs
- `you_won` Bla bla bal fs
- `they_won` Bla bla bal fs
- `draw` Bla bla bal fs


#### `board` (String[])

The board is a **list of nine chars**, that represent the indexed markings of the fields in the 3x3 grid of the game.

A single field can have one of these values:

- `f` Free (default)
- `x` Marked by player X
- `o` Marked by player O

The indices represent the grid like this:

```
<%= AsciiBoardState.encode(%w(0 1 2 3 4 5 6 7 8)).join("\n") %>
```

#### `player_token` (String)

There is no registration, each game creates two completely new players.

Each player gets a `player_token` when they either create or join a fresh game.

This player token needs to be provided for all further calls to identify the player.

#### `player_role` (String)

The role of the current player which is also the mark the player can set on the board, either `x` or `o`.

#### `next_move_token` (String | null)

In order to create a new move on the player's behalf, a client must also always send a `next_move_token`.

This token will be regenerated after each move. It prevents race-conditions in your calls and proves that the move is meant to be applied to a very specific board state.

If the player is not allowed to perform a move, the `next_move_token` is null.

#### `created_at` and `updated_at`

The `created_at` and `updated_at` timestamps are purely informational and should not be necessary for the proper implementation of a client.


## The `Error` object

### Example

```
{
  message: "this did not work :("
}
```

### Attributes

#### `message` (String)

An error message describing the problem.

---

# API Docs

asdlfjhsdalf dslfkj asdfklsjadfsldakj

## Authentication

## Start a new game


**Request**

```
POST https://fly.io/tictactoe/games
```

**Responses**

- `201` A new `Game` object
- `422` An `Error` object

....

asdlfjhsdalf dslfkj asdfklsjadfsldakj

## Join a game

**Request**

```
POST https://fly.io/tictactoe/games/<existing-game-id>/join
```

**Responses**

- `201` The joined `Game` object
- `404` The game was not found
- `422` An `Error` object

## Get a game

**Request**

```
GET https://fly.io/tictactoe/games/<game-name>?player_token=<player-token>
```

**Responses**

- `200` The current `Game` object
- `404` The game was not found
- `401` An `Error` object - You did not provide a valid `player_token`

....

## Make a move

**Request**

```
POST https://fly.io/tictactoe/games/<game-name>/moves?player_token=<player-token>

{
  next_move_token: "<next-move-token>"
  field: "0"
}
```

**Params**

- `next_move_token` - ...
- `field` - ...

**Responses**

- `201` The updated `Game` object
- `401` An `Error` object - You did not provide a valid `player_token`
- `422` An `Error` object

-----

```
<%= AsciiBoardState.encode(%w(0 1 2 3 4 5 6 7 8)).join("\n") %>
```

<article>
Final note:
This API is meant to be used at a one-day hackathon. Therefore this API is designed in a way that it can be used in a pragmatic way, even if this might hurt some best practices in REST-API design.
</article>
