# Honorable Kills Forever

**See your honorable kills at a glance, right on the PvP window.**

Honorable Kills Forever is a World of Warcraft add-on made for **World of Warcraft Forever**. It adds a small panel to the PvP tab of your character window. The panel shows how many honorable kills you have in total, today and yesterday, plus a total for your whole account.

## Features

- **Your kills on the PvP window**: lifetime total, today and yesterday, displayed on the PvP tab of the character window.
- **Account-wide total**: adds up the honorable kills of all your characters. Hover the panel to see each character's count, sorted from highest to lowest and colored by class.
- **Live updates**: the panel updates after every honorable kill, in battlegrounds or in the open world, and refreshes each time you open the window.
- **Combat-safe**: if the game hides the numbers during combat, the panel keeps the last values and updates as soon as combat ends.
- **Movable**: Shift + drag the panel anywhere on the window. Its position is saved.
- **English and French**: texts follow your game client's language.
- **Lightweight**: no dependencies, nothing to set up.

## Slash commands

| Command | Effect |
| --- | --- |
| `/hk` | Print your honorable kills in chat |
| `/hk reset` | Move the panel back to its default position |
| `/hk attach <FrameName>` | Show the panel on another frame |
| `/hk auto` | Go back to automatic detection of the PvP window |
| `/hk forget <Name>` | Remove a character from the account total |
| `/hk help` | List the commands |

`/honorablekillsforever` works the same as `/hk`.

## About the account total

The game doesn't provide an account-wide count, so the add-on saves each character's total when that character logs in, and adds them up.

- A character is counted once it has logged in with the add-on installed. Log in each of your characters once to complete the total.
- If you delete a character, remove it from the total with `/hk forget <Name>`.

## Installation

- **CurseForge app**: search for "Honorable Kills Forever" and install it like any other add-on.
- **Manually**: create a folder named `HonorableKillsForever` in the `Interface\AddOns` folder of your World of Warcraft Forever installation. Put `HonorableKillsForever.toc` and `HonorableKillsForever.lua` in it, so that you get `Interface\AddOns\HonorableKillsForever\HonorableKillsForever.toc`. Then restart the game or type `/reload`.

The folder must be named `HonorableKillsForever` exactly. A folder named after this repository (`honorable-kills-forever`) won't load.

## FAQ

**The panel doesn't appear.**
Open the PvP tab of your character window. If it still doesn't show, type `/hk`: it tells you which window the panel is attached to. If the game's PvP window has changed, hover it, type `/fstack` to find its name, then use `/hk attach <FrameName>`.

**The account total looks too low.**
Characters are only counted after they log in once with the add-on. Log in each of them once.

**Does the add-on send my data anywhere?**
No. Everything stays on your computer, in the add-on's saved variables file. Add-ons cannot access the internet.

## Feedback

Found a bug or have an idea? [Open an issue](https://github.com/LGentila/honorable-kills-forever/issues). Screenshots help a lot.
