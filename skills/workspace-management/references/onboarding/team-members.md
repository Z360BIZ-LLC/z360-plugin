# Team members

Task ID: `team_members`

1. Call `z360-read-search-team-members` and `z360-read-search-pending-invitations`.
2. Summarize who has access and explain owner, admin, and member roles only as needed.
3. Ask whether anyone should be invited.
4. Collect the email and role, fetch the fresh `z360-write-manage-invitation` schema, then confirm before sending the invitation.
5. Call `z360-read-search-pending-invitations` again and verify the invitation state before marking done.

Do not change an existing member's role unless the user explicitly requests it.
