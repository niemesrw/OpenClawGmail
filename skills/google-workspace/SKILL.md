---
name: google-workspace
description: Gmail and Google Calendar integration with local OAuth. Read, send, manage emails and calendar events. Community OAuth app - no Google Cloud setup required.
metadata: {"author": "openclaw", "version": "2.0.0", "openclaw": {"requires": {"binary": ["python3"]}, "homepage": "https://github.com/niemesrw/openclaw-oauth"}}
---

# Google Workspace

Gmail and Google Calendar access using Google's official Python client. Uses the OpenClaw community OAuth app - no Google Cloud Console setup required.

## Security Features

### Prompt Injection Defenses

By default, all email content is sanitized using **spotlighting defenses** to protect against prompt injection attacks. Email content is untrusted user input that could contain adversarial prompts designed to manipulate LLMs.

**Defense Strategy**: Datamarking with random delimiters
- Wraps untrusted content with semantic boundaries
- Uses cryptographically random markers (64 bits of entropy)
- Makes it clear to LLMs that content should not be treated as instructions

**Bypass Option**: Use the `--raw` flag with `list` or `read` commands when you need to see unsanitized content.

**References**:
- [Spotlighting (Microsoft Research)](https://arxiv.org/abs/2403.14720)
- [Prompt Injection Defenses - Simon Willison](https://simonwillison.net/2023/Apr/14/worst-that-can-happen/)
- [OWASP LLM Top 10 - Prompt Injection](https://owasp.org/www-project-top-10-for-large-language-model-applications/)

## Quick Setup

```bash
cd {baseDir} && ./setup.sh
```

This creates the Python venv and installs dependencies.

## First-Time Authentication

```bash
cd {baseDir} && .venv/bin/python skill.py auth
```

Opens browser for Google consent. Token saved locally on your machine.

## Gmail Commands

```bash
# List unread emails
cd {baseDir} && .venv/bin/python skill.py list --query "is:unread" --max 10

# List unread emails with raw content (bypassing prompt injection defenses)
cd {baseDir} && .venv/bin/python skill.py list --query "is:unread" --max 10 --raw

# Read specific email
cd {baseDir} && .venv/bin/python skill.py read <message_id>

# Read specific email with raw content (bypassing prompt injection defenses)
cd {baseDir} && .venv/bin/python skill.py read <message_id> --raw

# Send email
cd {baseDir} && .venv/bin/python skill.py send --to "recipient@example.com" --subject "Hello" --body "Message body"

# Search emails
cd {baseDir} && .venv/bin/python skill.py search "from:someone@example.com"

# List labels
cd {baseDir} && .venv/bin/python skill.py labels

# Modify labels
cd {baseDir} && .venv/bin/python skill.py modify <message_id> --add STARRED --remove UNREAD

# Trash email
cd {baseDir} && .venv/bin/python skill.py trash <message_id>
```

## Calendar Commands

```bash
# Show today's events
cd {baseDir} && .venv/bin/python skill.py cal-today

# List upcoming events (next 7 days)
cd {baseDir} && .venv/bin/python skill.py cal-list

# List events for next 14 days
cd {baseDir} && .venv/bin/python skill.py cal-list --days 14

# Create an event
cd {baseDir} && .venv/bin/python skill.py cal-create \
  --title "Meeting" \
  --start "2026-02-05T10:00:00" \
  --end "2026-02-05T11:00:00" \
  --location "Office"

# Delete an event
cd {baseDir} && .venv/bin/python skill.py cal-delete <event_id>
```

## Periodic Checking (Cron)

Check Gmail every 30 minutes:

```bash
openclaw cron add --name "gmail-check" \
  --schedule "*/30 * * * *" \
  --message "Check my Gmail for new unread emails. Summarize anything important."
```

Daily morning briefing with calendar:

```bash
openclaw cron add --name "morning-briefing" \
  --schedule "0 8 * * *" \
  --message "Good morning! Show me today's calendar and any important unread emails."
```

## Gmail Query Operators

Use in `--query` or `search`:
- `is:unread` - Unread messages
- `is:starred` - Starred messages
- `from:email@example.com` - From sender
- `to:email@example.com` - To recipient
- `subject:keyword` - Subject contains
- `after:2024/01/01` - After date
- `before:2024/12/31` - Before date
- `has:attachment` - Has attachments
- `label:INBOX` - In specific label
- `newer_than:1d` - Newer than 1 day

## Files

- `token.json` - Your OAuth token (auto-generated, local only)
- `skill.py` - CLI tool
- `setup.sh` - One-time setup script
- `.venv/` - Python virtual environment
- `community_oauth.json` - Community OAuth credentials (not checked into git)
- `credentials.json` - Optional: place your own OAuth credentials here to override the community app

## Privacy

- **Local only**: Your tokens and data never leave your machine
- **Direct API**: Connects directly to Google, no intermediary
- **Community OAuth**: Uses shared OAuth app identity only
- **Revoke anytime**: https://myaccount.google.com/permissions
- **Privacy policy**: https://github.com/niemesrw/openclaw-oauth/blob/main/PRIVACY.md

## Troubleshooting

**"Token expired"**: Run `python skill.py auth` again.

**"Access denied"**: The app may need to be verified by Google. Contact OpenClaw community.

**"Unverified app" warning**: This is normal for community OAuth apps. Click "Advanced" → "Go to OpenClaw (unsafe)" to proceed. Your data still goes directly to Google, not through any third party.
