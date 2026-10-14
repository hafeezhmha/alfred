#!/usr/bin/env python3
"""ALFRED's page: a calm view of today in the browser, served on loopback.

The markdown files are the only source; this keeps no state of its own. It
reads queue.md, week.md, current.md and the name in AGENTS.md, and it writes
only by running ./life (done, add), so ids, dates and the Now limit stay the
launcher's job. Standard library only. Run it through the launcher:

  ./life page          open it now (starts the server if needed)
  ./life page on|off   open it at every session start, or stop it

  python3 .claude/page.py open [--if-closed] | stop | serve | html
"""
import hashlib
import html
import json
import os
import re
import signal
import subprocess
import sys
import threading
import time
from datetime import date, datetime
from pathlib import Path
from urllib.request import urlopen

ROOT = Path(__file__).resolve().parent.parent
PORT = int(os.environ.get("LIFE_PAGE_PORT", "4391"))
URL = f"http://127.0.0.1:{PORT}/"
PIDFILE = ROOT / ".life" / "page.pid"
WATCHED = ("queue.md", "week.md", "current.md", "AGENTS.md")
DAYS = ("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
LOCK = threading.Lock()
SEEN = {"t": 0.0}  # when an open tab last asked /sha; a tab polls every few seconds


def read(name):
    p = ROOT / name
    return p.read_text(encoding="utf-8").replace("\r\n", "\n") if p.exists() else ""


def digest():
    return hashlib.sha256("\0".join(read(n) for n in WATCHED).encode("utf-8")).hexdigest()


def unfenced(text):
    out, fence = [], False
    for line in text.splitlines():
        if line.startswith("```"):
            fence = not fence
        elif not fence:
            out.append(line)
    return out


def section(text, name):
    out, on = [], False
    for line in unfenced(text):
        if line.startswith("## "):
            on = line == "## " + name
        elif on:
            out.append(line)
    return out


def items(text, name):
    return [re.sub(r"^- (\[[ xX]\] )?", "", ln).strip() for ln in section(text, name) if ln.startswith("- ")]


def inline(s):
    s = html.escape(s.strip())
    s = re.sub(r"`([^`]+)`", r"<code>\1</code>", s)
    return re.sub(r"\*\*([^*]+)\*\*", r"<b>\1</b>", s)


def days_since(iso):
    try:
        return (date.today() - date.fromisoformat(iso)).days
    except ValueError:
        return None


def when(n):
    return "today" if n == 0 else "yesterday" if n == 1 else f"{n} days ago"


def stopped():
    """Where they left off: (date, topic, stopped at, energy) from the newest
    current.md entry that says. A "done" from the page starts today's entry
    without a stopped-at line, so the one before it still counts."""
    ents, label = [], None
    for line in unfenced(read("current.md")):
        if re.match(r"## 20\d\d-\d\d-\d\d", line):
            ents.append([line[3:13], re.sub(r"^## \S+\s*(—\s*)?", "", line), [], ""])
            label = None
            continue
        if not ents:
            continue
        e = ents[-1]
        m = re.match(r"(Working on|Done|Stopped at|Energy|Their words|Next):\s*(.*)", line)
        if m:
            label = m.group(1)
            if label == "Stopped at":
                e[2].append(m.group(2))
            elif label == "Energy":
                e[3] = m.group(2)
        elif not line.strip():
            label = None
        elif label == "Stopped at":
            e[2].append(line)
    for d, topic, at, energy in ents:
        at = " ".join(x.strip() for x in at if x.strip())
        if at:
            return d, topic, at, energy
    return (ents[0][0], ents[0][1], "", ents[0][3]) if ents else None


def name():
    m = re.search(r"^- \*\*Name:\*\* ([^.,\n]+)", read("AGENTS.md"), re.M)
    return m.group(1).strip() if m else ""


# --- the page ---------------------------------------------------------------

def card(title, body, cls=""):
    return f'<section class="card {cls}"><h2>{title}</h2>{body}</section>'


def fold(title, body, open_=False):
    return f'<details class="card"{" open" if open_ else ""}><summary>{title}</summary>{body}</details>'


def render():
    now = datetime.now()
    hello = "Good morning" if now.hour < 12 else "Good afternoon" if now.hour < 17 else "Good evening"
    who = name()
    greeting = f'{hello}, <span class="who">{html.escape(who)}</span>.' if who else f"{hello}."
    today_label = f"{DAYS[now.weekday()]} {now.day} {now.strftime('%b')}"

    if (ROOT / ".life" / "SETUP_NEEDED").exists():
        body = ('<div class="hud"><div><p class="lab">not set up yet</p>'
                '<h1>Say hello to ALFRED in your agent, or type /life.</h1>'
                '<p class="meta">Three questions, about three minutes. This page fills in after that.</p></div></div>')
        return page(greeting, today_label, body)

    week, queue = read("week.md"), read("queue.md")

    agreed = re.search(r"^Agreed: (20\d\d-\d\d-\d\d)", week, re.M)
    day = DAYS[now.weekday()]
    line = next((d for d in items(week, "Days") if d.lower().startswith(day.lower())), "") if agreed else ""
    today = inline(re.sub(r"^\w+:\s*", "", line)) if line else "Nothing agreed for today. Now is the plan."

    s = stopped()
    if s:
        ago = days_since(s[0])
        left = inline(s[2]) or inline(s[1]) or "Nothing recorded."
        left_meta = f'{inline(s[1])} &middot; {when(ago) if ago is not None else s[0]}'
        if s[3]:
            left_meta += f" &middot; energy: {inline(s[3])}"
    else:
        left, left_meta = "Nothing recorded yet.", ""

    hud = (f'<div class="hud"><div><p class="lab">where you left off</p><h1>{left}</h1>'
           f'<p class="meta">{left_meta}</p>'
           f'<div class="nextrow"><p class="lab">today, as agreed</p><p class="next">{today}</p></div></div></div>')

    if "## Now" not in queue:
        now_card = card("now", '<p class="muted">Your tasks live in another app (see queue.md). Ask ALFRED what today holds.</p>')
    else:
        rows = "".join(
            f'<li><span class="txt">{inline(t)}</span>'
            f'<button type="button" class="done" data-t="{html.escape(t, quote=True)}" aria-label="Mark done: {html.escape(t, quote=True)}">done</button></li>'
            for t in items(queue, "Now")
        )
        now_card = card("now", f'<ul class="now">{rows}</ul>' if rows else
                        '<p class="muted">Now is empty. Tell ALFRED what today is for.</p>')

    outcomes = items(week, "Outcomes") if agreed else []
    week_card = card("this week", '<ul class="plain">' + "".join(f"<li>{inline(o)}</li>" for o in outcomes) + "</ul>") if outcomes else ""

    jot = card("jot it down", '<label class="sr" for="note">Something to remember</label>'
               '<textarea id="note" rows="2" maxlength="300" placeholder="a thought, a task, a call to make..."></textarea>'
               '<div class="acts"><button type="button" id="add">Put it in the Inbox</button>'
               '<span>sorted later, with ALFRED</span></div>', "note")

    waiting = []
    for w in items(queue, "Waiting on"):
        m = re.search(r",?\s*since (20\d\d-\d\d-\d\d)\s*$", w)
        n = days_since(m.group(1)) if m else None
        text = w[: m.start()] if m else w
        waiting.append(f'<li>{inline(text)}' + (f' <span class="meta">&middot; waiting {n} days</span>' if n is not None else "") + "</li>")
    waiting_card = fold(f"waiting on ({len(waiting)})", f'<ul class="plain">{"".join(waiting)}</ul>'
                        '<p class="meta">Not yours to chase until it lands.</p>') if waiting else ""

    done = items(queue, "Done this week")
    done_card = fold(f"done this week ({len(done)})", '<ul class="plain wins">' + "".join(f"<li>{inline(d)}</li>" for d in done) + "</ul>", True) if done else ""

    body = (hud + '<div class="cols">'
            f'<div class="col">{now_card}{week_card}</div>'
            f'<div class="col">{jot}</div>'
            f'<div class="col">{done_card}{waiting_card}</div></div>')
    return page(greeting, today_label, body)


def page(greeting, today_label, body):
    return (PAGE.replace("@SHA@", digest())
            .replace("@ROOT@", html.escape(ROOT.name))
            .replace("@GREETING@", greeting)
            .replace("@DAY@", today_label)
            .replace("@BUTLER@", BUTLER)
            .replace("@BODY@", body))


# A pixel butler with a glass of cutting chai on his tray. 19 x 16 units; the
# steam rises in rows -2 to 1, so the viewBox starts at -2.
BUTLER = (
    '<svg class="butler" viewBox="0 -2 19 16" shape-rendering="crispEdges" aria-hidden="true"><g class="bob">'
    '<rect x="3" y="0" width="6" height="1" fill="#2b1d14"/><rect x="2" y="1" width="8" height="1" fill="#2b1d14"/>'
    '<rect x="3" y="2" width="6" height="3" fill="#c68a5c"/><rect x="2" y="3" width="1" height="1" fill="#c68a5c"/>'
    '<rect x="9" y="3" width="1" height="1" fill="#c68a5c"/>'
    '<g class="eyes"><rect x="4" y="3" width="1" height="1" fill="#141413"/><rect x="7" y="3" width="1" height="1" fill="#141413"/></g>'
    '<rect x="5" y="4" width="2" height="1" fill="#2b1d14"/>'
    '<rect x="2" y="6" width="8" height="4" fill="#4a4658"/><rect x="5" y="6" width="2" height="3" fill="#f2efe6"/>'
    '<rect x="4" y="5" width="1" height="1" fill="#d97757"/><rect x="7" y="5" width="1" height="1" fill="#d97757"/>'
    '<rect x="5" y="5" width="2" height="1" fill="#b05f42"/>'
    '<rect x="1" y="6" width="1" height="4" fill="#4a4658"/><rect x="1" y="10" width="1" height="1" fill="#c68a5c"/>'
    '<rect x="10" y="6" width="4" height="1" fill="#4a4658"/><rect x="14" y="6" width="1" height="1" fill="#c68a5c"/>'
    '<rect x="3" y="10" width="2" height="3" fill="#34313f"/><rect x="7" y="10" width="2" height="3" fill="#34313f"/>'
    '<rect x="2" y="13" width="3" height="1" fill="#5a3e2b"/><rect x="7" y="13" width="3" height="1" fill="#5a3e2b"/>'
    '<rect x="12" y="5" width="6" height="1" fill="#c9c9d1"/>'
    '<rect x="14" y="2" width="3" height="3" fill="#c68a4e"/><rect x="14" y="2" width="3" height="1" fill="#f0d9b5"/>'
    '<rect class="st" x="15" y="1" width="1" height="1" fill="#cdbfa6"/><rect class="st s2" x="14" y="0" width="1" height="1" fill="#cdbfa6"/>'
    '<rect class="st s3" x="15" y="-1" width="1" height="1" fill="#cdbfa6"/></g></svg>'
)

PAGE = """<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="alfred-sha" content="@SHA@">
<meta name="color-scheme" content="dark">
<title>ALFRED</title>
<style>
:root { --bg:#000; --win:#0a0806; --bar:#14100d; --line:#2b2118; --text:#e9dcc7; --dim:#a8957a; --coral:#d97757; --amber:#e8a317; --green:#7fd1a0;
  --mono:"Courier Prime","Courier New",Courier,"Liberation Mono","Nimbus Mono PS",monospace; }
*,*::before,*::after { box-sizing:border-box; }
body { margin:0; background:var(--bg); color:var(--text); font:15px/1.8 var(--mono); letter-spacing:.02em; }
main { max-width:1280px; margin:0 auto; padding:32px; }
.win { border:1px solid var(--line); border-radius:10px; background:var(--win); overflow:hidden; }
.titlebar { display:flex; align-items:center; gap:18px; padding:9px 20px; background:var(--bar); border-bottom:1px solid var(--line); font-size:12px; color:var(--dim); }
.dots { display:flex; gap:8px; } .dots i { width:10px; height:10px; border-radius:50%; background:var(--line); } .dots i:first-child { background:var(--coral); }
.titlebar .path { flex:1; } .titlebar b { color:var(--text); font-weight:400; }
.body { padding:16px 32px 8px; }
.hellorow { display:flex; flex-wrap:wrap; align-items:flex-end; gap:18px; margin-bottom:14px; }
.butler { width:114px; height:auto; flex:none; }
.butler .bob { animation:bob 3.2s ease-in-out infinite; }
.butler .eyes rect { transform-box:fill-box; transform-origin:center; animation:blink 5.5s infinite; }
.butler .st { animation:steam 2.8s ease-in-out infinite; } .butler .s2 { animation-delay:.9s; } .butler .s3 { animation-delay:1.8s; }
@keyframes bob { 50% { transform:translateY(-.35px); } }
@keyframes blink { 0%,94%,100% { transform:scaleY(1); } 97% { transform:scaleY(.1); } }
@keyframes steam { 0%,100% { opacity:0; transform:translateY(1px); } 50% { opacity:.9; transform:translateY(-1px); } }
.hello { margin:0 0 6px; color:var(--dim); } .hello .who { color:var(--coral); }
.hello::after { content:"_"; color:var(--coral); animation:cursor 1.1s steps(1) infinite; margin-left:2px; }
@keyframes cursor { 50% { opacity:0; } }
.clk { margin-left:auto; text-align:right; } .clk b { display:block; font-size:24px; line-height:1.2; } .clk span { font-size:12px; color:var(--dim); }
.hud { position:relative; padding:16px 28px; margin-bottom:22px; border:1px solid rgba(215,119,87,.45); border-radius:4px; background:#0d0907; }
.hud::before, .hud::after { content:""; position:absolute; width:14px; height:14px; border:2px solid var(--coral); }
.hud::before { top:-2px; left:-2px; border-right:0; border-bottom:0; } .hud::after { bottom:-2px; right:-2px; border-left:0; border-top:0; }
.lab { font-size:12px; color:var(--coral); margin:0 0 6px; }
.hud h1 { margin:0 0 4px; font-size:20px; line-height:1.55; overflow-wrap:anywhere; max-width:80ch; }
.nextrow { margin-top:12px; padding-top:10px; border-top:1px dashed rgba(215,119,87,.4); }
.next { margin:0; overflow-wrap:anywhere; max-width:90ch; }
.meta { font-size:12px; color:var(--dim); margin:0; } .muted { color:var(--dim); margin:0; }
code { color:var(--amber); }
.cols { display:grid; grid-template-columns:repeat(3,minmax(0,1fr)); gap:20px; }
@media (max-width:980px) { .cols { grid-template-columns:1fr; } .body { padding:14px 16px; } main { padding:10px; } .butler { width:84px; } .clk { display:none; } }
.card { border:1px solid var(--line); border-radius:6px; padding:12px 16px 14px; margin-bottom:20px; }
.col > :last-child { margin-bottom:0; }
.card h2, .card summary { font-size:12px; font-weight:400; color:var(--coral); margin:0 0 8px; cursor:default; }
details.card summary { cursor:pointer; } details.card:not([open]) summary { margin:0; }
ul { list-style:none; margin:0; padding:0; }
.now li { display:flex; gap:12px; align-items:baseline; padding:8px 0; border-bottom:1px dashed var(--line); } .now li:last-child { border:0; }
.now .txt { flex:1; overflow-wrap:anywhere; } .now li.gone .txt { color:var(--dim); text-decoration:line-through; }
.plain li { padding:3px 0; overflow-wrap:anywhere; } .plain li::before { content:"- "; color:var(--dim); }
.wins li::before { content:"+ "; color:var(--green); }
button { font:inherit; font-size:13px; color:var(--bg); background:var(--coral); border:0; border-radius:3px; padding:4px 12px; cursor:pointer; }
button.done { color:var(--coral); background:none; border:1px solid rgba(215,119,87,.6); }
button:focus-visible, textarea:focus-visible, summary:focus-visible { outline:2px solid var(--amber); outline-offset:2px; }
textarea { width:100%; font:inherit; color:var(--text); background:#000; border:1px solid var(--line); border-radius:4px; padding:8px; resize:vertical; }
.acts { display:flex; flex-wrap:wrap; gap:12px; align-items:center; margin-top:8px; } .acts span { font-size:12px; color:var(--dim); }
#status { min-height:1.8em; font-size:13px; color:var(--green); margin:6px 0 0; }
.sr { position:absolute; width:1px; height:1px; overflow:hidden; clip:rect(0 0 0 0); }
footer { padding:8px 32px 14px; font-size:12px; color:var(--dim); }
@media (prefers-reduced-motion: reduce) { *, *::before, *::after { animation:none !important; } }
</style></head>
<body><main><div class="win">
<div class="titlebar"><span class="dots"><i></i><i></i><i></i></span><span class="path"><b>alfred</b> ~/@ROOT@</span><span id="clock"></span></div>
<div class="body">
<div class="hellorow">@BUTLER@<div><p class="hello">@GREETING@</p></div>
<div class="clk"><b id="time"></b><span>@DAY@</span></div></div>
@BODY@
<p id="status" role="status"></p>
</div>
<footer>The files are the truth. This page reads them, writes only through ./life, and refreshes when they change.</footer>
</div></main>
<script>
const sha = document.querySelector('meta[name="alfred-sha"]').content;
const status = document.getElementById("status");
const note = document.getElementById("note");
let busy = 0;
function tick() { const d = new Date(); document.getElementById("time").textContent = d.toTimeString().slice(0, 5); }
tick(); setInterval(tick, 10000);
function say(t) { status.textContent = t; }
async function act(body) {
  const r = await fetch("/act", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(body) });
  const t = await r.text();
  if (!r.ok) throw new Error(t);
  return t;
}
// A tick waits five seconds before it is written, so a stray click can be taken back.
document.querySelectorAll("button.done").forEach(b => b.addEventListener("click", () => {
  const li = b.closest("li");
  if (b.dataset.timer) { clearTimeout(+b.dataset.timer); delete b.dataset.timer; li.classList.remove("gone"); b.textContent = "done"; busy--; say("Kept in Now."); return; }
  busy++; li.classList.add("gone"); b.textContent = "undo"; say("Marking it done in 5 seconds. Undo keeps it.");
  b.dataset.timer = setTimeout(async () => {
    delete b.dataset.timer;
    try { say(await act({ op: "done", text: b.dataset.t })); setTimeout(() => location.reload(), 900); }
    catch (e) { li.classList.remove("gone"); b.textContent = "done"; busy--; say(e.message); }
  }, 5000);
}));
async function add() {
  const t = note.value.trim(); if (!t) { note.focus(); return; }
  try { say(await act({ op: "add", text: t })); note.value = ""; }
  catch (e) { say(e.message); }
}
const addBtn = document.getElementById("add");
if (addBtn) {
  addBtn.addEventListener("click", add);
  note.addEventListener("keydown", e => { if (e.key === "Enter" && !e.shiftKey) { e.preventDefault(); add(); } });
}
// When ALFRED changes the files in the chat, the page follows, unless you are mid-way through something here.
setInterval(async () => {
  try {
    const r = await fetch("/sha"); const now = await r.text();
    if (now !== sha && !busy && !(note && note.value.trim())) location.reload();
  } catch (e) {}
}, 4000);
</script>
</body></html>
"""


# --- the server ---------------------------------------------------------------

def life(*args):
    r = subprocess.run(["bash", str(ROOT / "life"), *args], cwd=ROOT, capture_output=True, text=True, timeout=30)
    out = (r.stdout if r.returncode == 0 else r.stderr).strip().splitlines()
    msg = re.sub(r"^error: ", "", out[0]) if out else ""
    return r.returncode == 0, msg


def act(req):
    """One write, through ./life. Returns (ok, message for the person)."""
    op, text = req.get("op"), " ".join(str(req.get("text", "")).split())
    if not text or len(text) > 300:
        return False, "Nothing to save (or it's over 300 characters)."
    if op == "add":
        ok, msg = life("add", text)
        return ok, "In the Inbox. ALFRED sorts it with you later." if ok else msg
    if op == "done":
        # Resolve to an id now, against the file as it is, so a stale page
        # can never tick the wrong item.
        now = items(read("queue.md"), "Now")
        if text not in now:
            return False, "That item has moved since the page loaded. Refreshing."
        ok, msg = life("done", f"n{now.index(text) + 1}")
        return ok, "Done. It's in Done this week and today's log." if ok else msg
    return False, "Unknown action."


def serve():
    from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

    hosts = (f"127.0.0.1:{PORT}", f"localhost:{PORT}")
    origins = tuple("http://" + h for h in hosts)

    class H(BaseHTTPRequestHandler):
        def log_message(self, *a):
            pass

        def send(self, code, body, ctype="text/plain; charset=utf-8"):
            data = body.encode("utf-8")
            self.send_response(code)
            self.send_header("Content-Type", ctype)
            self.send_header("Content-Length", str(len(data)))
            self.send_header("Cache-Control", "no-store")
            self.end_headers()
            self.wfile.write(data)

        def do_GET(self):
            # Host stops DNS rebinding: only this machine's own page gets data.
            if self.headers.get("Host", "") not in hosts:
                return self.send(403, "forbidden")
            if self.path == "/sha":
                SEEN["t"] = time.time()
                return self.send(200, digest())
            if self.path == "/whoami":
                seen = time.time() - SEEN["t"] if SEEN["t"] else None
                return self.send(200, json.dumps({"root": str(ROOT), "seen": seen}), "application/json")
            if self.path in ("/", "/index.html"):
                return self.send(200, render(), "text/html; charset=utf-8")
            self.send(404, "not found")

        def do_POST(self):
            # Origin and an exact JSON type stop cross-site posts (no CORS headers are ever sent).
            if (self.headers.get("Host", "") not in hosts or self.path != "/act"
                    or self.headers.get("Origin") not in origins
                    or self.headers.get_content_type() != "application/json"):
                return self.send(403, "forbidden")
            try:
                n = int(self.headers.get("Content-Length", "0"))
                if not 0 < n <= 4096:
                    return self.send(413, "Too long.")
                req = json.loads(self.rfile.read(n))
                if not isinstance(req, dict):
                    raise ValueError
                with LOCK:
                    ok, msg = act(req)
                self.send(200 if ok else 409, msg)
            except ValueError:
                self.send(400, "Bad request.")
            except Exception:
                self.send(500, "Couldn't save. The files are unchanged; ask ALFRED in the chat.")

    srv = ThreadingHTTPServer(("127.0.0.1", PORT), H)
    PIDFILE.parent.mkdir(exist_ok=True)
    PIDFILE.write_text(str(os.getpid()))
    srv.serve_forever()


# --- open and stop --------------------------------------------------------------

def whoami():
    try:
        with urlopen(URL + "whoami", timeout=1) as r:
            return json.loads(r.read())
    except Exception:
        return None


def ours(w):
    return bool(w) and w.get("root") == str(ROOT)


def stop():
    if not ours(whoami()):
        return False
    try:
        os.kill(int(PIDFILE.read_text()), signal.SIGTERM)
    except (OSError, ValueError):
        return False
    for _ in range(20):
        if not whoami():
            break
        time.sleep(0.1)
    PIDFILE.unlink(missing_ok=True)
    return True


def open_page(if_closed):
    w = whoami()
    if w and not ours(w):
        print(f"error: port {PORT} is in use by another ALFRED ({w.get('root')}). "
              f"Pick another port: LIFE_PAGE_PORT=4392 ./life page", file=sys.stderr)
        return 2
    if w is None:
        try:
            with urlopen(URL, timeout=1):
                pass
            print(f"error: port {PORT} is in use by another program. Pick another: LIFE_PAGE_PORT=4392 ./life page", file=sys.stderr)
            return 2
        except Exception:
            pass
    # A server older than this script is restarted, so an update shows up.
    if ours(w) and PIDFILE.exists() and Path(__file__).stat().st_mtime > PIDFILE.stat().st_mtime:
        stop()
        w = None
    if not ours(w):
        subprocess.Popen([sys.executable, "-I", str(Path(__file__).resolve()), "serve"], cwd=ROOT,
                         stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                         start_new_session=True)
        for _ in range(30):
            w = whoami()
            if ours(w):
                break
            time.sleep(0.1)
        else:
            print("error: the page server didn't start. Try: python3 .claude/page.py serve", file=sys.stderr)
            return 2
    # At session start, a tab that is already open is enough. Background tabs
    # poll slowly, so "open" means it asked within the last 90 seconds.
    tab_open = w.get("seen") is not None and w["seen"] < 90
    if not (if_closed and tab_open) and not os.environ.get("LIFE_PAGE_NO_BROWSER"):
        import webbrowser
        webbrowser.open(URL)
    print(f"page: {URL}")
    return 0


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else "open"
    if cmd == "open":
        return open_page("--if-closed" in sys.argv)
    if cmd == "stop":
        stop()
        return 0
    if cmd == "serve":
        serve()
        return 0
    if cmd == "html":
        sys.stdout.write(render())
        return 0
    print(__doc__.strip(), file=sys.stderr)
    return 2


if __name__ == "__main__":
    sys.exit(main())
