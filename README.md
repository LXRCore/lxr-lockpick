# LXR-Lockpick 🔓

**LXR-Lockpick** is a dynamic and customizable lockpicking system for the **LXRCore** framework. It brings an immersive lockpicking experience to your RedM server, whether it's cracking safes, picking doors, or unlocking cars, this resource has got you covered!

---

## Features ✨
- **Interactive Lockpicking**: Realistic and skill-based lockpicking mini-game for players.
- **Customizable Difficulty**: Adjust the difficulty level to fit your server’s needs.
- **Multi-Purpose**: Supports doors, safes, vehicles, and more!
- **Failure Consequences**: Optional consequences such as item breakage or alarms.
- **Integrated with LXRCore**: Seamless integration with LXRCore, making setup a breeze.

---

## Installation 🛠️

### 1. Download & Install

- **Download** the script and place it in your `[lxr]` directory.

### 2. Add to `server.cfg`

Add the following lines to your `server.cfg` to ensure it’s loaded:

```bash
ensure lxr-core
ensure lxr-lockpick
```

---

## Configuration ⚙️

You can tweak various options in the `config.lua` file, such as:

- **Lockpicking Difficulty**: Adjust how challenging it is for players to pick locks.
- **Failure Consequences**: Define what happens when a player fails (e.g., lockpick breaking, alarms triggering).
- **Supported Objects**: Add or remove objects that can be lockpicked (doors, safes, vehicles, etc.).

---

## Example Usage 🚪

Here’s a simple example of how you might use **LXR-Lockpick** in a script:

```lua
-- Example of lockpicking a door
local door = GetClosestObjectOfType(playerCoords, 1.5, `prop_door`, false, false, false)
if door then
    TriggerEvent('lxr-lockpick:attempt', door)
end
```

---

## Screenshots 📸
Coming soon! Stay tuned for visuals showcasing the thrilling lockpicking experience.

---

## Roadmap & Future Updates 🚀
- **Lockpick Crafting**: Add the ability for players to craft lockpicks.
- **Advanced Security Systems**: For high-value targets, add more sophisticated lock systems with alarms.
- **Custom Animations**: Immersive lockpicking animations to make the experience even more engaging.

---

## License 📄

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

With **LXR-Lockpick**, breaking into places has never been this much fun! Unlock new possibilities for your RedM server and give your players a thrilling challenge!

