# Web Multi-Agent Prototype

This document describes the static Web prototype in `web/`. The Web version is not a replacement for the Rokid AIUI page. It is a browser-facing simulator for making the multi-agent product model visible and easier to discuss.

## Purpose

The AIUI version focuses on what the glasses wearer sees: a compact life danmaku layer over the current scene.

The Web version focuses on how the system decides what to show:

- Which scene is active.
- Which memory signals are retrieved.
- Which persona agents are allowed to draft comments.
- Which safety rules pass, soften, or mute candidates.
- Which candidate the arbiter selects.
- Which final danmaku reaches the renderer.

## Files

```text
web/
|-- index.html
|-- styles.css
|-- app.js
`-- assets/
    `-- scene-rain-cafe.png
```

The prototype uses plain HTML, CSS, and JavaScript. There is no build step and no package manager requirement.

## Running Locally

Use a static server:

```powershell
py -m http.server 5173 -d web
```

Then open:

```text
http://localhost:5173
```

If `5173` is occupied, choose another free port:

```powershell
py -m http.server 5174 -d web
```

The page can also be opened directly from `web/index.html`.

## Product Model

The prototype represents a generation run as a visible pipeline:

```text
Scene Parser
-> Memory Retriever
-> Persona Agents
-> Safety Moderator
-> Arbiter
-> Danmaku Renderer
```

Each run answers one question: given the current scene, active personas, intensity, quiet mode, and safety settings, what single comment should be allowed onto the life danmaku layer?

## Agent Roles

### Scene Parser

Locks the current scene preset and exposes the scene name, confidence, scan label, and signal. Supported scenes match the AIUI prototype:

- `street`
- `cafe`
- `office`
- `gym`
- `store`
- `subway`

### Memory Retriever

Selects memory signals related to the active scene. These are used to explain why a comment appears now rather than making the AI output feel arbitrary.

### Persona Agents

Draft candidate comments. The current prototype includes:

- Friend
- Therapist
- Childhood self
- Cat
- Mentor
- Parallel self

Each persona can be enabled or disabled. Persona strength limits whether higher-intensity lines can participate.

### Safety Moderator

Reviews candidates before arbitration. A candidate can receive:

- `pass`: allowed as written.
- `soften`: allowed only after tone adjustment.
- `mute`: blocked from output.

Quiet mode and safety settings can make the moderator prefer therapist-style or neutral comments.

### Arbiter

Scores surviving candidates with a simple local heuristic based on novelty, memory fit, persona strength, quiet mode, intensity, and safety margin. The highest-scoring surviving candidate becomes the final pick.

### Danmaku Renderer

Displays the final comment over the simulated glasses viewport unless output is paused or all candidates are blocked.

## Main Interactions

- Scene buttons switch the active environment and rebuild the discussion run.
- Intensity controls filter how sharp or lively comments can be.
- Quiet mode prefers softer, lower-risk output.
- Pause suppresses renderer output while preserving the rest of the interface.
- Generate rebuilds the current multi-agent run.
- The Agents tab toggles persona participation and strength.
- The Safety tab toggles moderator rules and shows recent verdicts.
- Clicking a danmaku or candidate opens its detail drawer.
- Saving a comment marks it as a personal highlight candidate.

## Prototype Boundaries

This is intentionally local and deterministic. It does not use:

- Real camera input.
- Real microphone input.
- Real user memory import.
- Live model calls.
- Authentication or persistence.
- Production telemetry.

Those are product and platform questions for later iterations. The current goal is to make the decision model inspectable.

## Verification Checklist

Before committing changes to the Web prototype:

1. Run `node --check web/app.js`.
2. Start a local static server.
3. Confirm the page loads without console errors.
4. Confirm the scene image loads.
5. Confirm scene switching updates the status and candidates.
6. Confirm Generate rebuilds the run.
7. Confirm Agents and Safety controls change the final output.
8. Confirm the page has no horizontal overflow on desktop or narrow mobile widths.
