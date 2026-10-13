# CodeCrafter Logic Cloud

A game-based learning tool that teaches beginner programming concepts through logic puzzles instead of syntax. Built in Godot 4.5 as my Final Year Project for the Bachelor of Computer Science (Hons.) at UiTM.

## Why

Beginners often get stuck on syntax before they understand the ideas behind it. CodeCrafter lets players drag, connect and combine blocks to see how data types, Boolean logic and functions behave, with no typing required.

## Features

- **Data types**: sort and combine coloured blocks to learn how values of different types behave.
- **Boolean logic**: wire inputs through AND / OR / NOT style nodes with toggles to reach the target output.
- **Functions**: build reusable combinations across three function levels.
- **Tutorials and How to Play** screens before each concept.
- **Level select with unlockable levels**: finishing a level opens the next one in its category.

## Evaluation

Tested with 10 users: **81.4% positive feedback and no negative responses**.

## Tech stack

Godot 4.5 (Forward+) · GDScript

## Running it

1. Install [Godot 4.5](https://godotengine.org/download).
2. Clone this repo and open `project.godot` in Godot.
3. Press **F5**. The game starts at the main menu (`Scene/main_menu.tscn`).

## Project layout

| Path | Contents |
| --- | --- |
| `Scene/` | Main menu, level select, How to Play and shared UI scenes |
| `Code/` | Menu, level and wiring logic |
| `Mechanic Script/` | Drag-and-drop and node-combining mechanics |
| `Level*.tscn`, `Tutorial*.tscn` | Puzzle levels and tutorials |
| `Video/` | Gameplay recordings |
