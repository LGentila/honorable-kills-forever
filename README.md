# Honorable Kills Forever

**See your honorable kills at a glance: on the PvP window, or always on screen.**

Honorable Kills Forever is a World of Warcraft add-on made for **World of Warcraft Forever**. It shows how many honorable kills you have in total, today and yesterday, plus a total for your whole account. You can see them on the PvP tab of your character window, and on a small counter that stays on your screen while you play.

## Features

- **Your kills on the PvP window**: lifetime total, today, yesterday and account total, displayed on the PvP tab of the character window.
- **On-screen counter**: the same numbers, visible at all times while you play. Turn it on in the options and place it wherever you like.
- **Choose what you see**: tick the lines you want (total, today, yesterday, account), separately for the counter and for the PvP window.
- **Account-wide total**: adds up the honorable kills of all your characters. Hover the panel or the counter to see each character's count, sorted from highest to lowest and colored by class.
- **Daily history**: each character's honorable kills are saved day by day. They are not shown yet: future versions will use them.
- **Live updates**: the numbers update after every honorable kill, in battlegrounds or in the open world.
- **Combat-safe**: if the game hides the numbers during combat, the add-on keeps the last values and updates as soon as combat ends.
- **English and French**: texts follow your game client's language.
- **Lightweight**: no dependencies. It works as soon as it is installed.

## Options

Press Esc, click **Options**, open the **AddOns** tab and select **Honorable Kills**. You can also right-click the panel or the counter.

**On-screen counter**

- **Show the counter on the screen**: turns the counter on or off. It is off by default.
- **Lines**: the lines the counter shows. By default: total, today and yesterday.
- **Lock position**: uncheck it to move the counter with the mouse. It locks again when you close the options, so you can't move it by mistake while you play. The first time you turn the counter on, it is unlocked so that you can place it right away.
- **Reset position**: puts the counter back in its default place, on the left of the screen.

**PvP window**

- **Show the panel on the PvP window**: turns the panel on or off.
- **Lines**: the lines the panel shows. By default, all of them.
- To move the panel, hold Shift and drag it on the PvP window. Its position is saved.

**Characters on this account**

The characters counted in the account total. If you delete a character, click **Remove** next to it, then **Confirm?**. The character you are playing can't be removed.

Changes apply right away, to all your characters.

## About the account total

The game doesn't provide an account-wide count, so the add-on saves each character's total when that character logs in, and adds them up.

- A character is counted once it has logged in with the add-on installed. Log in each of your characters once to complete the total.
- Characters are recognized by their full name: first name and surname. Two characters can share a first name.
- If you delete a character, remove it from the total in the options.

## Installation

- **CurseForge app**: search for "Honorable Kills Forever" and install it like any other add-on.
- **Manually**: create a folder named `HonorableKillsForever` in the `Interface\AddOns` folder of your World of Warcraft Forever installation. Put `HonorableKillsForever.toc` and `HonorableKillsForever.lua` in it, so that you get `Interface\AddOns\HonorableKillsForever\HonorableKillsForever.toc`. Then restart the game or type `/reload`.

The folder must be named `HonorableKillsForever` exactly. A folder named after this repository (`honorable-kills-forever`) won't load.

## FAQ

**The panel doesn't appear on the PvP window.**
In the options, check that **Show the panel on the PvP window** is ticked, with at least one line. Then open the PvP tab of your character window. If it still doesn't show, see **Slash commands** below.

**I can't find the counter.**
In the options, tick **Show the counter on the screen**. If you still can't see it, click **Reset position**: it goes back to the left of the screen.

**How do I move the counter?**
In the options, uncheck **Lock position**, drag the counter, then close the options.

**The account total looks too low.**
Characters are only counted after they log in once with the add-on. Log in each of them once.

**A character is listed twice, or with a name like "CAMWOW EU5 Realm 8 PvP".**
That name is an internal server name. The game gave it to add-ons as a realm name until the 20 November 2026 hotfix, and gives none since. Version 2.0.1 then saved the character a second time and counted it twice. Since version 2.0.2, both entries are merged the next time that character logs in.

**Does the daily history take a lot of space?**
No. A day takes about 25 bytes, and only days with at least one honorable kill are saved: two years of daily play take less than 20 KB per character.

**Does the add-on send my data anywhere?**
No. Everything stays on your computer, in the add-on's saved variables file. Add-ons cannot access the internet.

## Slash commands

You don't need them: everything is in the options. They are there for players who like to type commands.

| Command | Effect |
| --- | --- |
| `/hk` | Print your honorable kills in chat |
| `/hk options` | Open the options |
| `/hk reset` | Put the panel and the counter back in their default positions |
| `/hk attach <FrameName>` | Show the PvP panel on another frame |
| `/hk auto` | Go back to automatic detection of the PvP window |
| `/hk forget <Name>` | Remove a character from the account total |
| `/hk help` | List the commands |

`/honorablekillsforever` works the same as `/hk`.

If the game's PvP window has changed and the panel no longer appears on it, hover the window, type `/fstack` to find its name, then use `/hk attach <FrameName>`.

## Feedback

Found a bug or have an idea? [Open an issue](https://github.com/LGentila/honorable-kills-forever/issues). Screenshots help a lot.
