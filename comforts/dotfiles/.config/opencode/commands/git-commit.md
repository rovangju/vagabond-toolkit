---
description: Generate a git commit message
<!-- model: anthropic/claude-haiku-4-5 -->
---

Examine uncommited (staged and unstaged) changes and take into consideration the recent conversation history to propose a git commit message.
It should follow the "Conventional commits" (https://www.conventionalcommits.org/en/v1.0.0/) format. 

If uncertain what type of commit it is, ask questions to clarify.

Confirm acceptance of proposed commit message before adding and committing the changes associated with the message. 
Do not propose additional follow up actions such as testing, etc, focus only on crafting commits and commit messages 
to minimize context. 

After presenting the proposed commit message, ask for a simple Yes or No approval. A Yes approval means perform the commit with the message.
