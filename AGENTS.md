When the user says exactly `commit`:
- MUST delegate to the custom agent named `commit`.
- The parent agent MUST NOT inspect Git or generate the commit message itself.
- Return the `commit` agent result verbatim.
