# Phone number

Task ID: `phone_number`

Read `../workspace-management/references/workspace-settings.md`. Use the Z360 action group and fetch a fresh schema before every action.

1. Call `z360-read-search-phone-collections`, then use `z360-read-search-phone-numbers` to check the organization's existing unassigned and collection-assigned numbers.
2. If no suitable number exists, ask for the preferred US area code and call `z360-read-search-phone-numbers-to-buy`.
3. Present two or three available numbers when possible. Obtain explicit confirmation of the exact E.164 number before calling `z360-write-buy-phone-number`.
4. Call `z360-read-search-phone-numbers` again to verify ownership and returned activation state.
5. If routing or assignment still needs configuration, explain the proposed state and confirm it before calling `z360-write-update-phone-number`, then read the number back again.

Never buy a number automatically. If none is available, offer a nearby area code or leave the task in progress.
