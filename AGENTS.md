# Agent Workflow Rules

- **Do NOT automatically push to GitHub**:
  - Never execute `git push` automatically after completing AI-driven code edits.
  - Always run, reload, and verify the application in web debug mode first.
  - Explicitly ask the user for confirmation via a prompt before pushing any commits to GitHub.
