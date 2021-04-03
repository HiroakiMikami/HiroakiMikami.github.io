Experimentation plays an essential role in exploratory programming, and programmers apply version control operations when switching the part of the source code back to the past state during experimentation. However, these operations, which we refer to as <i>micro-versioning</i>, are not well supported in current programming environments.
We first examined previous studies to clarify the requirements for a micro-versioning tool. We then developed a micro-versioning tool that displays visual cues representing possible micro-versioning operations in a textual code editor. Our tool includes a history model that generates meaningful candidates by combining a regional undo model and tree-structured undo model. The history model uses code executions as a delimiter to segment text edit operations into meaning groups.
A user study involving programmers indicated that our tool satisfies the above-mentioned requirements and that it is useful for exploratory programming.