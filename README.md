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
