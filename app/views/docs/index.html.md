# Tik Tak Tioki API Docs

- [General Game Concept](#general-game-concept)
- [Resources](#resources)
  - [The Game object](#the-game-object)
  - [The Error object](#the-error-object)
- [Endpoints](#endpoints)
  - [Start a new game](#start-a-new-game)
  - [Find a game to join](#find-a-game-to-join)
  - [Join a game](#join-a-game)
  - [Load a game](#load-a-game)
  - [Make a move](#make-a-move)
- [Debugger](#debugger)

## Game Concept

The [Wikipedia](https://en.wikipedia.org/wiki/Tic-tac-toe) article sums up the game like this:

Tic-tac-toe is played on a three-by-three grid by two players, who alternately place the marks X and O in one of the nine spaces in the grid.

The player who succeeds in placing three of their marks in a horizontal, vertical, or diagonal row is the winner.

### Game Server Concepts

In order to play a game of Tic-Tac-Toe a `Game` has to be created by a client.

The client that creates a new game will always be `Player X`.

To start playing, another client has to join the game.

The client that joins the game will always be `Player O`.

The system randomly chooses who is allowed to move first.

If it's the player's turn, the active player then can send a `move` request to the server, marking a free field on the game board.

If it's the other player's turn, the inactive player needs to watch/poll the game state of the server to fetch the last move of the other player and switch into the active player role after that.

The server will determine if one of the players has won the game or the game ended in a draw.

---

# Resources

## The `Game` object

The `Game` object projects the state of a game for the authenticated player.

It is the response of all successful calls to the endpoints of the API.

### Example

```json
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

The state of the current game.

- `awaiting_join` You are waiting for a second player to join the game.
- `your_turn` It is your turn and you mask make a move.
- `their_turn` It's the other player's turn. You have to wait until they made a move.
- `you_won` Game is over because you won.
- `they_won` Game is over because the other player won.
- `draw` Game is over, no one could win.


#### `board` (String[])

The board is a **list of nine chars**, that represent the indexed markings of the fields in the 3x3 grid of the game.

A single field can have one of these values:

- `f` Free (default)
- `x` Marked by player X
- `o` Marked by player O

The indices represent the grid like this:

```language-plain
<%= AsciiBoardState.encode(%w(0 1 2 3 4 5 6 7 8)).join("\n") %>
```

#### `player_token` (String)

<mark>There is no registration, each game creates two completely new players.</mark>

Each player gets a `player_token` when they either create or join a fresh game.

This player token needs to be provided for all further calls to identify the player.

#### `player_role` (String)

The role of the current player which is also the mark the player can set on the board, either `x` or `o`.

#### `next_move_token` (String | null)

In order to create a new move on the player's behalf, a client must also always send a `next_move_token`.

This token will be regenerated after each move. It prevents race-conditions in your calls and proves that the move is meant to be applied to a very specific board state.

If the player is not allowed to perform a move, the `next_move_token` is `null`.

#### `created_at` and `updated_at`

The `created_at` and `updated_at` timestamps are purely informational and should not be necessary for the proper implementation of a client.


## The `Error` object

### Example

```json
{
  "message": "This did not work :("
}
```

### Attributes

#### `message` (String)

An error message describing the problem.

---

# Endpoints

The following endpoints are provided and can be used to build a complete client for the game.


## Start a new game

**Request**

```http
POST <%= api_game_url %>
Content-Type: application/json
```

**Responses**

- `201` A new `Game` object
- `422` An `Error` object

This is the starting point for every game.

One client needs to create a game.

When the game is created, the client will act on behalf of `Player X` using the `player_token`.

Once the game has been created, the client needs to wait for another player to join the game.


## Find a game to join

**Request**

```http
GET <%= api_join_url %>
Content-Type: application/json
```

**Responses**

- `200` A new list of minimal `Game` objects (just containing `name` and `created_at`)

This endpoint returns a list of recently created games (last five minutes) that still can be joined by a second player.

```json
[
  {
    "name": "panoramic-cicada-8502",
    "created_at": "2022-07-21T08:29:21.828Z"
  },
  {
    "name": "treasure-lark-2510",
    "created_at": "2022-07-21T08:24:53.390Z"
  }
]
```


## Join a game

**Request**

```http
POST <%= api_join_url %>
Content-Type: application/json
```

```json
{
  "name": "<existing-game-name>"
}
```

**Responses**

- `201` The joined `Game` object
- `404` The game was not found
- `422` An `Error` object

Besides creating a game, a client can also join a newly-created game that is awaiting a second player.

In order to join a game, the client needs to know the `Game#name`.

When the game is joined, the newly joined client will act on behalf of `Player O` using the `player_token`.

Once the second player joined, it will be randomly chosen who will get the first move.


## Load a game

**Request**

```http
GET <%= api_game_url(params: { player_token: "YOUR-PLAYER-TOKEN" }) %>
Content-Type: application/json
```

**Responses**

- `200` The current `Game` object
- `404` The game was not found
- `401` An `Error` object - You did not provide a valid `player_token`

In order to update the current game state, clients need to fetch the latest information about ongoing games.

Notable changes include:

- Checking if it was the other players' turn or now yours
- If it is your turn: Updating the `next_move_token`
- Checking if the game is still ongoing or if somebody won or it's a draw

## Make a move

**Request**

```http
POST <%= api_move_url(params: { player_token: "YOUR-PLAYER-TOKEN" }) %>
Content-Type: application/json
```

```json
{
  "next_move_token": "<next-move-token>"
  "field": 0
}
```

**Params**

- `next_move_token` - The token in the payload of the current game that proves the client knows the current state of the game
- `field` - The field index on the board to set the mark on

**Responses**

- `201` The updated `Game` object
- `401` An `Error` object - You did not provide a valid `player_token`
- `422` An `Error` object - Another error occured, you provided incomplete or invalid data

-----

```plain
<%= AsciiBoardState.encode(%w(0 1 2 3 4 5 6 7 8)).join("\n") %>
```

# Debugger

This API server comes with a built-in <%= link_to "debugger view", debugger_index_path %> that allows you to view the current game state for your player.
