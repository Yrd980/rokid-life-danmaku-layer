# Rokid Life Danmaku Layer

Rokid Life Danmaku Layer is a Rokid Glass AIUI prototype for a real-time AI life commentary overlay. It explores how lightweight, persona-driven comments can appear as an ambient heads-up layer over everyday scenes such as streets, cafes, offices, gyms, stores, and subway rides.

The prototype is named **Life Danmaku** in the app UI. Its core idea is to turn scene understanding, personal memory signals, and safety controls into short contextual "danmaku" comments that feel present without taking over the user's attention.

## What It Does

- Presents a Rokid Glass-style AIUI interface for life commentary.
- Simulates live scene understanding across common daily environments.
- Shows persona-based AI comments, including friend, therapist, childhood self, mentor, and parallel-self voices.
- Connects each comment to a visible reason and memory reference.
- Includes controls for persona strength, comment intensity, safety mode, and daily recap concepts.
- Uses Rokid Glass AIUI visual design guidance and the green wearable theme language.

## Project Status

This repository is an early prototype. It is intended for interaction design, AIUI workflow exploration, and visual experimentation rather than production deployment.

## Repository Structure

```text
.
|-- app.js
|-- app.json
|-- app.wxss
|-- pages/
|   `-- index/
|       `-- index.ink
|-- web/
|   |-- index.html
|   |-- styles.css
|   |-- app.js
|   `-- assets/
|-- .agents/
|   `-- skills/
|       |-- aiui-dev/
|       `-- rokid-glass-aiui-design/
|-- AGENTS.md
`-- skills-lock.json
```

## Key Files

- `pages/index/index.ink` contains the main Life Danmaku AIUI screen, scene data, persona data, danmaku examples, and interaction logic.
- `web/` contains a static browser prototype that exposes the multi-agent discussion and arbitration flow behind the life danmaku layer.
- `app.json` registers the app page and window metadata.
- `app.wxss` defines app-level visual styling and theme token overrides.
- `.agents/skills/` contains local agent skills used to guide AIUI development and Rokid Glass visual design.
- `AGENTS.md` documents the project manifest, permissions, and agent capabilities.

## Web Prototype

The Web version is a static prototype for exploring the multi-agent product model behind the glasses overlay.

It shows:

- Scene input and mode controls.
- A glasses-style live viewport with danmaku output.
- A visible multi-agent pipeline: scene parser, memory retriever, persona agents, safety moderator, arbiter, and renderer.
- Candidate comments with safety verdicts and arbiter scoring.
- Persona, memory, NPC, recap, and safety panels.

Run it with a local static server:

```powershell
py -m http.server 5173 -d web
```

Then open:

```text
http://localhost:5173
```

If `5173` is already in use, choose any free local port and update the URL accordingly.

The prototype also works by opening `web/index.html` directly in a browser.

## AIUI Data Inputs

The main page accepts optional scene input through the `initialScene`, `liveScene`, or `sceneUnderstanding` data fields.

Supported preset scene ids:

- `street`
- `cafe`
- `office`
- `gym`
- `store`
- `subway`

Example live scene payload:

```json
{
  "liveScene": {
    "id": "cafe",
    "name": "Cafe",
    "confidence": "89%",
    "signal": "Repeat iced Americano behavior detected",
    "scan": "CAFFEINE",
    "summary": "User is in a cafe context with repeat order behavior."
  }
}
```

## Design Principles

- Keep the interface glanceable for wearable displays.
- Make AI commentary contextual, short, and interruptible.
- Explain why each comment appears instead of presenting AI output as magic.
- Treat memory-aware content as sensitive and keep safety controls visible.
- Prefer theme tokens and Rokid Glass AIUI design rules over page-specific visual hacks.

## Permissions

The prototype manifest declares these capabilities:

- Camera
- Microphone
- Network
- Audio

These permissions describe the intended AIUI experience surface. Actual runtime behavior depends on the target Rokid AIUI environment and host integration.

## Development Notes

This project follows the local AIUI development conventions captured in `.agents/skills/aiui-dev/` and `.agents/skills/rokid-glass-aiui-design/`. When changing the UI, keep edits scoped to the AIUI page and use the existing theme tokens before introducing new visual constants.

## License

No license has been selected yet. Add a license before using this project outside personal or internal prototype work.
