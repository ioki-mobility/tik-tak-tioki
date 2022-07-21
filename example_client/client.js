// Ah yes, the one global variable that keeps it all together
// aka the game state
let game = null;

// ----------------------------------------------
// API communication with the TicTacToe server
// ----------------------------------------------

const baseURL = "https://tik-tak-tioki.fly.dev/api";

// Make a request to the server.
// If the requests suceeds:
// - update global game state (lucky you, each successful response IS the game state)
// - trigger onGameUpdate() to react to new state
const request = async (method = "GET", endpoint = "", data = false) => {
  const options = {
    method: method,
    mode: "cors",
    headers: {
      "Content-Type": "application/json",
    },
  };

  if (data) {
    options.body = JSON.stringify(data);
  }

  const response = await fetch(`${baseURL}${endpoint}`, options);
  const json = await response.json();

  if (response.ok) {
    game = json;
    onGameUpdate();
  } else {
    renderGenericError(json);
    throw json;
  }

  return json;
};

// ----------------------------------------------
// API endpoints
// ----------------------------------------------

const createGame = () => request("POST", "/game");

const joinGame = ({ name }) => request("POST", "/join", { name });

const updateGame = () => {
  const endPointWithToken = `/game?player_token=${game.player_token}`;
  return request("GET", endPointWithToken);
};

const makeMove = (field) => {
  const data = {
    field: field,
    next_move_token: game.next_move_token,
  };

  const endPointWithToken = `/move?player_token=${game.player_token}`;
  return request("POST", endPointWithToken, data);
};

// ----------------------------------------------
// Handle user input
// ----------------------------------------------

const onStartNewGame = () => {
  createGame().then(() => hideMenu());
};

const onJoinExistingGame = (event) => {
  const name = prompt("Enter name of the game to join");
  joinGame({ name }).then(() => hideMenu());
};

const onMarkField = (field) => makeMove(field);

// ----------------------------------------------
// Game logic
// ----------------------------------------------

const onGameUpdate = () => {
  if (game.state === "draw") {
    renderMessage("Game over: DRAW!");
  } else if (game.state === "you_won") {
    renderMessage("Game over: YOU WON!");
  } else if (game.state === "they_won") {
    renderMessage("Game over: YOU LOST!");
  } else if (game.state === "awaiting_join") {
    renderMessage("Waiting for other player...");
    enqueueGameUpdate();
  } else if (game.state === "your_turn") {
    renderMessage("Your turn! Make a move.");
  } else if (game.state === "their_turn") {
    renderMessage("Wait for other player to make a move...");
    enqueueGameUpdate();
  }

  updateBoard();
  renderGameDump();
};

const enqueueGameUpdate = () => {
  setTimeout(() => updateGame(), 1000);
};

// ----------------------------------------------
// Render logic for UI updates
// ----------------------------------------------

const updateBoard = () => {
  game.board.forEach((field, i) => {
    const canMakeMoveOnField = game.state === "your_turn" && field === "f";
    const label = field === "f" ? i : field;
    const el = document.getElementById(`field_${i}`);

    el.disabled = !canMakeMoveOnField;
    el.innerText = label;
  });
};

const renderMessage = (message) => {
  document.getElementById("status").innerText = message;
};

const renderGenericError = (e) => console.error(e);

const renderGameDump = () => {
  document.getElementById("dump").innerHTML = JSON.stringify(game, null, 2);
};

const hideMenu = () => {
  document.getElementById("menu").style.display = "none";
};
