# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an OpenClaw skill providing Gmail and Google Calendar integration via local OAuth. It uses Google's official Python client libraries and includes an embedded community OAuth app, so users don't need to set up their own Google Cloud project.

## Commands

### Setup
```bash
./setup.sh           # Create venv and install dependencies
./setup.sh auth      # Setup + run OAuth authentication
```

### Running the CLI
```bash
.venv/bin/python skill.py <command> [options]
```

### Available Commands

**Gmail:**
- `auth` - Authenticate with Google (opens browser)
- `list [--query Q] [--max N]` - List recent emails
- `read <message_id>` - Read a specific email
- `send --to <email> --subject <s> --body <b> [--cc <emails>]` - Send email
- `search <query> [--max N]` - Search emails
- `labels` - List all Gmail labels
- `modify <message_id> --add/--remove <labels>` - Modify message labels
- `trash <message_id>` - Move message to trash

**Calendar:**
- `cal-today` - Show today's events
- `cal-list [--days N] [--max N]` - List upcoming events
- `cal-create --title <t> --start <iso> --end <iso> [--description <d>] [--location <l>] [--timezone <tz>]` - Create event
- `cal-delete <event_id>` - Delete event

## Architecture

Single-file Python CLI (`skill.py`) with these key components:

- **OAuth flow**: Uses PKCE (Proof Key for Code Exchange) for secure authorization. The embedded `COMMUNITY_OAUTH` credentials work for all users; placing a custom `credentials.json` overrides it.
- **Token storage**: OAuth tokens saved to `token.json` (gitignored). Tokens auto-refresh when expired.
- **API services**: `get_gmail_service()` and `get_calendar_service()` return authenticated Google API clients.
- **Command routing**: `main()` uses argparse with subcommands, dispatched via a `commands` dict to handler functions (`cmd_*`).

## Key Files

| File | Purpose |
|------|---------|
| `skill.py` | Main CLI with all commands |
| `SKILL.md` | OpenClaw skill manifest and user documentation |
| `community_oauth.json` | Community OAuth credentials (gitignored, required if no credentials.json) |
| `token.json` | OAuth tokens (auto-generated, gitignored) |
| `credentials.json` | Optional: custom OAuth credentials override |

## API Scopes

The skill requests these Google API scopes:
- `gmail.readonly`, `gmail.send`, `gmail.modify`, `gmail.labels`
- `calendar.readonly`, `calendar.events`

## Dependencies

Uses `uv` (per user preference) or pip:
```bash
uv pip install -r requirements.txt
```

Core dependencies: `google-api-python-client`, `google-auth-httplib2`, `google-auth-oauthlib`

## TODO

- [ ] **Prompt injection defense**: Email content is untrusted user input that could contain malicious prompts. Consider implementing spotlighting defenses (delimiter, datamarking, base64-encoding) before passing email content to LLMs. See: https://github.com/realArcherL/spotlighting-datamarking
