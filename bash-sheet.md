# Bash parameter-expansion cheat sheet — replace & trim (${...})

Quick summary
- ${var#pattern}    — remove shortest matching prefix
- ${var##pattern}   — remove longest matching prefix
- ${var%pattern}    — remove shortest matching suffix
- ${var%%pattern}   — remove longest matching suffix
- ${var/pat/repl}   — replace first occurrence of pat with repl
- ${var//pat/repl}  — replace all occurrences
- ${var/#pat/repl}  — replace pat at start (prefix)
- ${var/%pat/repl}  — replace pat at end (suffix)
- ${var:offset} / ${var:offset:length} — substring extraction
- ${#var}           — length of var

Notes
- Patterns are shell globs, not regular expressions.
- Always quote expansions when values may contain whitespace: "${var/...}"
- For portability, rely on POSIX-compatible constructs; extglob and negative offsets require Bash.

