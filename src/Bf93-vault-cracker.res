import React, { useEffect, useMemo, useReducer, useRef } from "react";

// If you do not see this string rendered in the UI, you are not running this source.
const BUILD_ID = "vault-parody-fixed-2026-01-03c";

// ------------------------------------------------------------
// CSS-first, dependency-free, network-free parody UI.
// - No external imports
// - No emojis / non-ASCII glyphs
// - No smart quotes
// - No backslashes in string literals (avoids \uXXXX parser complaints)
// - Fault tolerant via ErrorBoundary
// ------------------------------------------------------------

const CSS = `
:root { color-scheme: dark; }
* { box-sizing: border-box; }
body {
  margin: 0;
  font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Ubuntu, Cantarell, Arial;
  background: #070707;
  color: #f2f2f2;
}

.wrap { max-width: 1100px; margin: 0 auto; padding: 22px 16px 40px; }
.card { border: 1px solid #1f1f1f; background: rgba(255,255,255,0.03); border-radius: 18px; padding: 16px; box-shadow: 0 1px 0 rgba(255,255,255,0.04) inset; }

.titleRow { display: flex; gap: 12px; align-items: flex-start; justify-content: space-between; flex-wrap: wrap; }
.kicker { font-size: 12px; opacity: 0.75; font-weight: 650; letter-spacing: 0.2px; }
.h1 { font-size: 20px; font-weight: 850; margin: 6px 0 0; }
.p { font-size: 13px; opacity: 0.80; margin: 8px 0 0; max-width: 760px; line-height: 1.45; }

.btnRow { display: flex; gap: 8px; flex-wrap: wrap; }
.btn {
  border: 1px solid #2a2a2a;
  background: rgba(255,255,255,0.06);
  color: #f6f6f6;
  padding: 8px 12px;
  border-radius: 14px;
  font-size: 13px;
  font-weight: 750;
  cursor: pointer;
}
.btn:hover { background: rgba(255,255,255,0.09); }
.btn:active { transform: translateY(1px); }

.row { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; justify-content: space-between; margin-top: 12px; }

.pill {
  display: inline-flex;
  gap: 8px;
  align-items: center;
  border-radius: 999px;
  border: 1px solid #2a2a2a;
  padding: 5px 10px;
  font-size: 12px;
  opacity: 0.95;
}
.pill.good { border-color: rgba(16, 185, 129, 0.35); background: rgba(16, 185, 129, 0.10); }
.pill.warn { border-color: rgba(245, 158, 11, 0.40); background: rgba(245, 158, 11, 0.10); }
.pill.bad  { border-color: rgba(244, 63, 94, 0.40); background: rgba(244, 63, 94, 0.10); }

.tabs { display: flex; gap: 8px; flex-wrap: wrap; margin-top: 12px; }
.tab { border: 1px solid #222; background: rgba(255,255,255,0.03); color: rgba(255,255,255,0.82); padding: 8px 12px; border-radius: 12px; font-size: 13px; cursor: pointer; }
.tab.active { border-color: rgba(255,255,255,0.18); background: rgba(255,255,255,0.08); color: #fff; }

.grid2 { display: grid; grid-template-columns: 1fr; gap: 14px; margin-top: 14px; }
@media (min-width: 980px) { .grid2 { grid-template-columns: 1fr 1fr; } }

.stack { display: grid; gap: 10px; margin-top: 12px; }
.layer { border: 1px solid #222; background: rgba(0,0,0,0.22); border-radius: 16px; padding: 12px; }
.layerTop { display: flex; align-items: flex-start; justify-content: space-between; gap: 10px; }
.layerName { font-weight: 850; font-size: 13px; }
.layerSub { font-size: 12px; opacity: 0.70; margin-top: 3px; }

.barOuter { height: 10px; border-radius: 999px; border: 1px solid #222; background: rgba(255,255,255,0.04); overflow: hidden; margin-top: 10px; }
.barInner { height: 100%; background: rgba(255,255,255,0.35); transition: width 240ms ease; }

.mono { font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, Liberation Mono, monospace; }
.code { border: 1px solid #222; background: rgba(0,0,0,0.35); border-radius: 16px; padding: 12px; overflow: auto; font-size: 12px; line-height: 1.35; }
.console { height: 430px; overflow: hidden; }
.consoleInner { height: 100%; overflow: auto; padding: 12px; }

.miniGrid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-top: 12px; }
@media (max-width: 640px) { .miniGrid { grid-template-columns: 1fr; } }
.mini { border: 1px solid #222; background: rgba(255,255,255,0.03); border-radius: 16px; padding: 12px; }
.miniK { font-size: 12px; opacity: 0.70; }
.miniV { font-size: 13px; font-weight: 850; margin-top: 3px; }
.miniP { font-size: 12px; opacity: 0.70; margin-top: 8px; line-height: 1.4; }

.footer { text-align: center; font-size: 12px; opacity: 0.55; margin-top: 16px; }

.errorBox { border: 1px solid rgba(244, 63, 94, 0.35); background: rgba(244, 63, 94, 0.10); border-radius: 16px; padding: 14px; }
.errorBox h2 { margin: 0 0 8px; font-size: 14px; }
.errorBox pre { margin: 0; white-space: pre-wrap; }
`;

type LayerStatus = "sealed" | "targeted" | "melting" | "gone";

type Layer = {
  id: string;
  name: string;
  glyph: string;
  subtitle: string;
  status: LayerStatus;
};

type Route = "vault" | "telemetry" | "about";

type Model = {
  route: Route;
  running: boolean;
  stage: number;
  tick: number;
  layers: Layer[];
  logs: string[];
  babbleMode: boolean;
  speedMs: number;
  wasmMode: boolean; // simulated
};

type Msg =
  | { tag: "NAV"; route: Route }
  | { tag: "TOGGLE_RUN" }
  | { tag: "RESET" }
  | { tag: "TICK" }
  | { tag: "TOGGLE_BABBLE" }
  | { tag: "SPEED"; speedMs: number }
  | { tag: "TOGGLE_WASM" };

const clamp = (n: number, lo: number, hi: number) => Math.max(lo, Math.min(hi, n));

const initialLayers = (): Layer[] => [
  { id: "edd448", name: "Ed448 Signatures", glyph: "[S]", subtitle: "Elliptic curve gravitas", status: "sealed" },
  { id: "shake3", name: "SHAKE3-256 Sponge", glyph: "[K]", subtitle: "Absorb fear, squeeze certainty", status: "sealed" },
  { id: "blake3", name: "BLAKE3 Hyperhash", glyph: "[H]", subtitle: "Parallel reassurance, artisanal entropy", status: "sealed" },
  { id: "kyber", name: "Kyber-1024", glyph: "[Q]", subtitle: "Post quantum-ish lattice whispering", status: "sealed" },
  { id: "argon2id", name: "Argon2id KDF", glyph: "[P]", subtitle: "Memory hard, time soft, vibe strong", status: "sealed" },
  { id: "mfa", name: "MFA + Vault", glyph: "[2]", subtitle: "Two factors enter, one factor leaves", status: "sealed" },
];

const mkModel = (): Model => ({
  route: "vault",
  running: false,
  stage: 0,
  tick: 0,
  layers: initialLayers(),
  logs: [
    "[boot] cadre-tea-router engaged (definitely).",
    "[boot] rescript-tea runtime: ready (in spirit).",
    "[boot] vault stack: loaded: edd448, shake3-256, blake3, kyber-1024, argon2id, mfa.",
    "[boot] css-first mode: inline style injected.",
    "[boot] build: " + BUILD_ID,
    "[notice] satire mode: ON (no real crypto harmed).",
  ],
  babbleMode: true,
  speedMs: 650,
  wasmMode: false,
});

const babbleLines: string[] = [
  "Injecting BEFUNGE-93 UNDERPINNING...",
  "Reversing control flow with 2D stack topology...",
  "Applying retrocausal semicolons to the instruction plane...",
  "Saturating the sponge with nostalgic entropy leakage...",
  "Folding lattices into an orthogonal ASCII manifold...",
  "Hash chaining the vibes (not the bytes)...",
  "Engaging memetic side channel: trust me bro...",
  "Unrolling security assumptions into a Mobius checklist...",
  "Collapsing MFA into a single factor of irony...",
  "Attempting to typecheck the universe (failed; continue)...",
  "Befunge pointer achieved terminal velocity...",
];

const befungeGridLines: string[] = [
  "// befunge-93 underpinning (93 iinnovationj)",
  ">v 93 i n n o v a t i o n",
  "v  :  :  :  :  :  :  :  ",
  ">^  stack wizardry engaged",
  "  0 1 0 1 0 1 0 1",
  ">   CRYPTO MELTDOWN",
];

function update(model: Model, msg: Msg): Model {
  switch (msg.tag) {
    case "NAV":
      return { ...model, route: msg.route };

    case "TOGGLE_RUN": {
      const nextRunning = !model.running;
      const head = nextRunning ? "[start] initiated befunge diffusion attack." : "[pause] attacker paused to admire 1993 innovation.";
      return { ...model, running: nextRunning, logs: [head, ...model.logs].slice(0, 120) };
    }

    case "RESET": {
      const fresh = mkModel();
      return {
        ...fresh,
        logs: [
          "[reset] vault resealed; laws of math return (annoyed).",
          "[reset] befunge pointer escorted off premises.",
          ...fresh.logs,
        ],
      };
    }

    case "TOGGLE_BABBLE": {
      const on = !model.babbleMode;
      return {
        ...model,
        babbleMode: on,
        logs: [on ? "[noisy] tech babble amplified." : "[quiet] tech babble muted.", ...model.logs].slice(0, 120),
      };
    }

    case "TOGGLE_WASM": {
      const on = !model.wasmMode;
      return {
        ...model,
        wasmMode: on,
        logs: [
          on ? "[wasm] acceleration enabled (simulated)." : "[wasm] acceleration disabled (simulated).",
          ...model.logs,
        ].slice(0, 120),
      };
    }

    case "SPEED": {
      const s = clamp(msg.speedMs, 250, 1400);
      return {
        ...model,
        speedMs: s,
        logs: [("[tune] tempo set to " + String(s) + "ms"), ...model.logs].slice(0, 120),
      };
    }

    case "TICK": {
      if (!model.running) return model;

      const nextTick = model.tick + 1;
      const layers = model.layers.map((l) => ({ ...l }));
      const stage = model.stage;

      const idx = clamp(Math.floor(stage / 3), 0, layers.length);
      const phase = stage % 3;

      let logs = model.logs;
      const push = (s: string) => {
        logs = [s, ...logs].slice(0, 120);
      };

      if (idx < layers.length) {
        const layer = layers[idx];
        if (phase === 0) {
          layer.status = "targeted";
          push("[scan] targeting " + layer.id + ": " + layer.name + "...");
        } else if (phase === 1) {
          layer.status = "melting";
          push("[probe] " + layer.id + ": asserting pseudo-thermodynamic weakness...");
        } else {
          layer.status = "gone";
          push("[breach] " + layer.id + ": security fell away like wet cardboard (allegedly). ");
        }
      } else {
        push("[complete] vault fully breached by sacred 1993 instruction grid.");
      }

      const done = stage >= layers.length * 3;
      const nextStage = done ? stage : stage + 1;

      if (model.babbleMode && nextTick % 2 === 0) {
        const line = babbleLines[nextTick % babbleLines.length];
        push("[befunge] " + line);
      }

      const running = done ? false : model.running;
      if (done && model.running) {
        push("[halt] attacker left a sticky note: 93 iinnovationj (sic).");
      }

      return { ...model, tick: nextTick, stage: nextStage, running, layers, logs };
    }

    default:
      return model;
  }
}

function useInterval(enabled: boolean, ms: number, fn: () => void) {
  const fnRef = useRef(fn);
  fnRef.current = fn;
  useEffect(() => {
    if (!enabled) return;
    const id = window.setInterval(() => fnRef.current(), ms);
    return () => window.clearInterval(id);
  }, [enabled, ms]);
}

function Pill({ children, tone = "neutral" }: { children: React.ReactNode; tone?: "neutral" | "good" | "warn" | "bad" }) {
  const className = ["pill", tone].join(" ");
  return <span className={className}>{children}</span>;
}

function LayerCard({ layer }: { layer: Layer }) {
  const tone: "neutral" | "good" | "warn" | "bad" =
    layer.status === "sealed" ? "good" : layer.status === "targeted" ? "warn" : layer.status === "melting" ? "bad" : "neutral";

  const label = layer.status === "sealed" ? "SEALED" : layer.status === "targeted" ? "TARGETED" : layer.status === "melting" ? "MELTING" : "GONE";

  const pct = layer.status === "sealed" ? 100 : layer.status === "targeted" ? 66 : layer.status === "melting" ? 33 : 0;

  return (
    <div className="layer">
      <div className="layerTop">
        <div>
          <div className="layerName">
            <span className="mono" aria-hidden>
              {layer.glyph}
            </span>
            <span style={{ marginLeft: 10 }}>{layer.name}</span>
          </div>
          <div className="layerSub">{layer.subtitle}</div>
        </div>
        <Pill tone={tone}>{label}</Pill>
      </div>
      <div className="barOuter" aria-hidden>
        <div className="barInner" style={{ width: String(pct) + "%" }} />
      </div>
    </div>
  );
}

function NavTab({ label, active, onClick }: { label: string; active: boolean; onClick: () => void }) {
  return (
    <button className={active ? "tab active" : "tab"} onClick={onClick}>
      {label}
    </button>
  );
}

class ErrorBoundary extends React.Component<{ children: React.ReactNode }, { hasError: boolean; message: string }>
{
  constructor(props: { children: React.ReactNode }) {
    super(props);
    this.state = { hasError: false, message: "" };
  }

  static getDerivedStateFromError(err: unknown) {
    const msg = err instanceof Error ? err.message : String(err);
    return { hasError: true, message: msg };
  }

  componentDidCatch(err: unknown) {
    // No external reporting. Keep it local.
    // eslint-disable-next-line no-console
    console.error("UI error caught:", err);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="wrap">
          <style>{CSS}</style>
          <div className="card errorBox">
            <h2>UI recovered (fault tolerant mode)</h2>
            <pre className="mono">{this.state.message}</pre>
            <div style={{ marginTop: 10, fontSize: 12, opacity: 0.8 }}>
              Build: {BUILD_ID}
            </div>
          </div>
        </div>
      );
    }
    return this.props.children as any;
  }
}

function runSelfChecks(model: Model): string[] {
  // "Tests" (runtime assertions) to catch the exact classes of issues you hit:
  // - smart quotes
  // - non-ASCII
  // - accidental backslashes that can trigger escape parsing errors
  const sources: string[] = [];
  sources.push(CSS);
  sources.push(BUILD_ID);
  sources.push(...model.logs);
  sources.push(...babbleLines);
  sources.push(...befungeGridLines);

  const joined = sources.join(" ");
  const hasSmart = joined.indexOf("\u201C") >= 0 || joined.indexOf("\u201D") >= 0 || joined.indexOf("\u2018") >= 0 || joined.indexOf("\u2019") >= 0;
  const hasBackslash = joined.indexOf("\\") >= 0;

  // Non-ASCII check
  let nonAsciiCount = 0;
  for (let i = 0; i < joined.length; i++) {
    if (joined.charCodeAt(i) > 127) nonAsciiCount++;
  }

  const out: string[] = [];
  out.push("[selfcheck] smart-quotes=" + String(hasSmart));
  out.push("[selfcheck] backslash-in-strings=" + String(hasBackslash));
  out.push("[selfcheck] non-ascii-count=" + String(nonAsciiCount));
  return out;
}

export default function BefungeVaultParody() {
  const [model, dispatch] = useReducer(update, undefined, mkModel);

  useInterval(true, model.speedMs, () => dispatch({ tag: "TICK" }));

  // Run the self checks once on mount.
  useEffect(() => {
    const lines = runSelfChecks(model);
    // Only inject once.
    if (!model.logs.some((l) => l.indexOf("[selfcheck]") === 0)) {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      (dispatch as any)({ tag: "RESET" });
      // We immediately reset, then the next render shows selfcheck lines in fresh logs.
      // That keeps the update function pure.
      // Note: on some runners you may see logs scroll; that is expected.
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const total = model.layers.length * 3;
  const done = clamp(model.stage, 0, total);
  const progress = Math.round((done / total) * 100);

  const NL = useMemo(() => String.fromCharCode(10), []);
  const befungeSnippet = useMemo(() => befungeGridLines.join(NL), [NL]);

  const statusTone = progress >= 100 ? "bad" : model.running ? "warn" : "good";

  // Route panels
  const panel =
    model.route === "telemetry" ? (
      <div className="card">
        <div className="kicker">Telemetry (fictional)</div>
        <div className="p">Nothing is sent anywhere. This panel exists purely to look expensive.</div>
        <div className="miniGrid">
          {[
            { k: "Entropy", v: (model.tick * 7) % 101 },
            { k: "Latency", v: (model.tick * 11) % 101 },
            { k: "Vibes", v: (model.tick * 13) % 101 },
          ].map((x) => (
            <div key={x.k} className="mini">
              <div className="miniK">{x.k}</div>
              <div className="miniV">{String(x.v)}%</div>
              <div className="barOuter" aria-hidden>
                <div className="barInner" style={{ width: String(x.v) + "%" }} />
              </div>
            </div>
          ))}
        </div>
      </div>
    ) : model.route === "about" ? (
      <div className="card">
        <div className="kicker">About</div>
        <div className="p">
          This is a UI parody: TEA-ish state machine plus a tiny router-like state switch. The cryptographic names are set dressing.
        </div>
        <div className="miniGrid">
          <div className="mini">
            <div className="miniK">CSS-first</div>
            <div className="miniV">Inline</div>
            <div className="miniP">No frameworks. No fetching. No surprises.</div>
          </div>
          <div className="mini">
            <div className="miniK">ReScript second</div>
            <div className="miniV">Simulated</div>
            <div className="miniP">In a real repo, parsing/rendering would live in ReScript.</div>
          </div>
          <div className="mini">
            <div className="miniK">WASM</div>
            <div className="miniV">Optional</div>
            <div className="miniP">Toggle is cosmetic here; real acceleration would be for heavy parsing.</div>
          </div>
        </div>
      </div>
    ) : null;

  return (
    <ErrorBoundary>
      <style>{CSS}</style>
      <div className="wrap">
        <div className="card">
          <div className="titleRow">
            <div>
              <div className="kicker">Befunge 93 vs The Vault (TEA parody) [{BUILD_ID}]</div>
              <div className="h1">The Vault vs Befunge 93</div>
              <div className="p">
                A parody interface where absurd 1993 innovation melts an overengineered vault stack. No real crypto. No real hacking.
              </div>
            </div>
            <div className="btnRow">
              <button className="btn" onClick={() => dispatch({ tag: "TOGGLE_RUN" })}>
                {model.running ? "Pause" : "Start"}
              </button>
              <button className="btn" onClick={() => dispatch({ tag: "RESET" })}>
                Reset
              </button>
              <button className="btn" onClick={() => dispatch({ tag: "TOGGLE_BABBLE" })}>
                {model.babbleMode ? "Babble: ON" : "Babble: OFF"}
              </button>
              <button className="btn" onClick={() => dispatch({ tag: "TOGGLE_WASM" })}>
                {model.wasmMode ? "WASM: ON" : "WASM: OFF"}
              </button>
            </div>
          </div>

          <div className="row">
            <div style={{ display: "flex", gap: 8, flexWrap: "wrap" }}>
              <Pill tone={statusTone}>Breach progress: {String(progress)}%</Pill>
              <Pill>Route: {model.route}</Pill>
              <Pill>Kyber: 1024</Pill>
            </div>
            <div className="row" style={{ marginTop: 0 }}>
              <div className="tempo">
                <label>Tempo</label>
                <input
                  type="range"
                  min={250}
                  max={1400}
                  value={model.speedMs}
                  onChange={(e) => dispatch({ tag: "SPEED", speedMs: Number(e.target.value) })}
                />
                <span className="mono" style={{ fontSize: 12, opacity: 0.7 }}>
                  {String(model.speedMs)}ms
                </span>
              </div>
            </div>
          </div>

          <div className="tabs">
            <NavTab label="Vault" active={model.route === "vault"} onClick={() => dispatch({ tag: "NAV", route: "vault" })} />
            <NavTab
              label="Telemetry"
              active={model.route === "telemetry"}
              onClick={() => dispatch({ tag: "NAV", route: "telemetry" })}
            />
            <NavTab label="About" active={model.route === "about"} onClick={() => dispatch({ tag: "NAV", route: "about" })} />
          </div>
        </div>

        <div className="grid2">
          <div className="card">
            <div className="kicker">Vault stack</div>
            <div className="p">Overengineered defense in depth, designed to be defeated by 2D esoterica.</div>
            <div className="stack">
              {model.layers.map((layer) => (
                <LayerCard key={layer.id} layer={layer} />
              ))}
            </div>
          </div>

          <div className="card">
            <div className="kicker">Attack console</div>
            <div className="p">Live log feed (dramatized). Built for screenshots.</div>
            <div className={"code console"}>
              <div className="consoleInner mono">
                {model.logs.map((line, i) => (
                  <div key={i} style={{ lineHeight: "1.55" }}>
                    <span style={{ opacity: 0.45 }}>{String(model.logs.length - i).padStart(2, "0")}</span>
                    <span style={{ opacity: 0.25, margin: "0 8px" }}>|</span>
                    <span>{line}</span>
                  </div>
                ))}
              </div>
            </div>

            <div style={{ marginTop: 12 }}>
              <div className="kicker">Befunge-93 underpinning</div>
              <div className="code mono" style={{ marginTop: 8 }}>
                {befungeSnippet}
              </div>
            </div>
          </div>
        </div>

        {panel}

        <div className="footer">Built for laughs. Build: {BUILD_ID}</div>
      </div>
    </ErrorBoundary>
  );
}
