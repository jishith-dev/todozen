# TODO Zen

A fast, minimal command-line task manager written in [Zen](https://github.com/jishith-dev/Zen), a statically-typed, AOT-compiled programming language. It compiles to a single native binary with no runtime or dependencies.

## Features

- Add tasks with a priority (`high`, `medium`, `low`)
- List all tasks, today's tasks, or completed tasks
- Mark tasks as completed, edit, search and remove them
- Task statistics with a completion rate
- Local JSON storage, no setup required
- Input validation with clear error messages

## Requirements

- [Zen](https://github.com/jishith-dev/Zen) **3.1.1 or higher**
- `git`

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/jishith-dev/todozen/main/install.sh | bash
```

The installer checks your Zen version, builds the project, installs the `todozen` command and removes the temporary build files.

### Build manually

```bash
git clone https://github.com/jishith-dev/todozen.git
cd todozen
zen build main.zen
./build/main help
```

## Usage

```
todozen <command> [arguments]
```

| Command                  | Description                       |
| ------------------------ | --------------------------------- |
| `add <title> [priority]` | Add a task (default: `medium`)    |
| `list`                   | Show all tasks                    |
| `today`                  | Show tasks created today          |
| `done`                   | Show completed tasks              |
| `finish [id]`            | Mark a task as completed          |
| `edit [id]`              | Edit title, priority or status    |
| `remove [id]`            | Remove a task (alias: `delete`)   |
| `search [id]`            | Find a task by ID                 |
| `stats`                  | Show task statistics              |
| `clear`                  | Delete all tasks (asks to confirm)|
| `help`                   | Show help                         |

Arguments in `[ ]` are optional. Commands that take an `[id]` prompt for it when it is omitted.

### Examples

```bash
todozen add "Buy milk"
todozen add "Fix the bug" high
todozen list
todozen finish 48614
todozen stats
```

## Data

Tasks are stored as JSON in `.todozen/todo_zen.json`, inside the directory where you run the command.

## License

Released under the [MIT License](LICENSE).

