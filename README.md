# The Game

![CI](https://github.com/caiodsc/the_game/actions/workflows/main.yml/badge.svg)
![Coverage Badge](https://img.shields.io/badge/Coverage-100%25-brightgreen)
 
The Game Challenge.

# Configuration

## Prerequisites

1. [Git](https://git-scm.com/)
2. [Docker](https://docs.docker.com/engine/install)
3. [Docker Compose](https://docs.docker.com/compose/install/standalone/)

## Project Setup

**1. Clone the Repository**

```bash
git clone https://github.com/caiodsc/the_game.git
cd the_game
```

**2. Build the Application**

```bash
sudo docker-compose build
```

# Quick Start

## Configure Bash Scripts
```bash
chmod +x start_server.sh run_tests.sh
```

## Running Tests

Execute the test suite with RSpec:

```bash
sh run_tests.sh
```

After running your tests, open `coverage/index.html` in the browser of your choice. For example, in a Mac terminal, run the following command from your application's root directory:

```bash
open coverage/index.html
```

In a Debian/Ubuntu terminal:

```bash
xdg-open coverage/index.html
```
Results:

## Running the Server

Run the server with the following command:

```bash
sh start_server.sh
```

Once the server is running, access the site at [localhost:3000](http://localhost:3000).

# Boards API Documentation

## Overview

The `BoardsController` provides endpoints for managing game boards. This includes creating new boards, viewing individual boards, advancing the board state, and calculating the final state.

## Endpoints

### 1. List All Boards

**Endpoint:** `GET /boards`

**Description:** Retrieves a list of all boards.

**Response:**

- **Status Code:** 200 OK
- **Content-Type:** application/json
- **Body:** An array of board objects.

```json
[
  {
    "id": 1,
    "grid": "[[0, 1], [1, 0]]",
    "created_at": "2024-09-01T00:00:00Z",
    "updated_at": "2024-09-01T00:00:00Z"
  }
]
```

### 2. Get a Specific Board

**Endpoint:** `GET /boards/:id`

**Description:** Retrieves a specific board by its ID.

**Parameters:**

- `id` (integer) - The ID of the board to retrieve.

**Response:**

- **Status Code:** 200 OK
- **Content-Type:** application/json
- **Body:** A board object.

```json
{
  "id": 1,
  "grid": "[[0, 1], [1, 0]]",
  "created_at": "2024-09-01T00:00:00Z",
  "updated_at": "2024-09-01T00:00:00Z"
}
```

### 3. Create a New Board

**Endpoint:** `POST /boards`

**Description:** Creates a new board with the provided grid.

**Parameters:**

- **Body:** A JSON object with the board's grid.

```json
{
  "board": {
    "grid": "[[0, 1], [1, 0]]"
  }
}
```
**Response:**

- **Status Code:** 201 Created
- **Content-Type:** application/json
- **Body:** The created board object.

```json
{
  "id": 1,
  "grid": "[[0, 1], [1, 0]]",
  "created_at": "2024-09-01T00:00:00Z",
  "updated_at": "2024-09-01T00:00:00Z"
}
```
- **Status Code:** 422 Unprocessable Entity (if validation fails)
- **Body:** Errors object.

```json
{
  "errors": {
    "grid": ["is invalid"]
  }
}
```

### 4. Advance Board State

**Endpoint:** `POST /boards/:id/next`

**Description:** Advances the board state by a specified number of generations.

**Parameters:**

- `id` (integer) - The ID of the board to update.
- `generations` (integer, optional) - The number of generations to advance. Defaults to 1.

**Response:**

- **Status Code:** 200 OK
- **Content-Type:** application/json
- **Body:** The updated board object.

```json
{
  "id": 1,
  "grid": "[[1, 0], [0, 1]]",
  "created_at": "2024-09-01T00:00:00Z",
  "updated_at": "2024-09-01T00:00:00Z"
}
```
- **Status Code:** 400 Bad Request (if there is an error)
- **Body:** Errors object.

```json
{
  "errors": {
    "generation": ["Exceeded max generations"]
  }
}
```
### 5. Get Final State

**Endpoint:** `POST /boards/:id/final_state`

**Description:** Calculates the final state of the board after running through all possible generations.

**Parameters:**

- `id` (integer) - The ID of the board to calculate.

**Response:**

- **Status Code:** 200 OK
- **Content-Type:** application/json
- **Body:** The final board object.

```json
{
  "id": 1,
  "grid": "[[0, 0], [0, 0]]",
  "created_at": "2024-09-01T00:00:00Z",
  "updated_at": "2024-09-01T00:00:00Z"
}
```
- **Status Code:** 400 Bad Request (if there is an error)
- **Body:** Errors object.

```json
{
  "errors": {
    "generation": ["Exceeded max generations"]
  }
}
```
