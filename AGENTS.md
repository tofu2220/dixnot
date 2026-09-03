## Git commit message workflow

When I ask `commit`, generate a commit message for the staged changes:

1. Inspect ONLY the changes currently staged in Git.
   - Run `git status --short`.
   - Run `git diff --cached --stat`.
   - Run `git diff --cached`.
2. Do not use unstaged or untracked changes to determine the commit message.
3. Do not run `git add`.
4. Do not run `git commit`.
5. Analyze the staged changes and write an accurate commit message in English.
6. Prefer Conventional Commits when appropriate, for example:
   - `feat: ...`
   - `fix: ...`
   - `refactor: ...`
   - `chore: ...`
   - `docs: ...`
   - `test: ...`
   - `style: ...`
   - `perf: ...`
7. The commit message should describe the actual intent of the staged changes, not just list filenames.
8. Return exactly one copyable bash code block containing the complete command:

   git commit -m "commit message"

9. Do not include explanations before or after the code block.
10. If there are no staged changes, do not invent a commit message. Say that there are no staged changes.
