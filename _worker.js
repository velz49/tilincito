// ============================================================
// VELZAR SCRIPTS  ============================================================

//
const PROTECTED_SCRIPTS = {
  "otc": "code:otc",
  "sexyboy-esp": "code:sexyboy-esp",
  "blockcopysb": "code:blockcopysb",
  "test": "code:test",
};

function randomId(bytes = 16) {
  const arr = crypto.getRandomValues(new Uint8Array(bytes));
  return [...arr].map((b) => b.toString(16).padStart(2, "0")).join("");
}

function jsonResponse(obj, status = 200) {
  return new Response(JSON.stringify(obj), {
    status,
    headers: { "Content-Type": "application/json; charset=utf-8" },
  });
}

// -
function rc4(bytes, keyStr) {
  const key = new TextEncoder().encode(keyStr);
  const S = new Uint8Array(256);
  for (let i = 0; i < 256; i++) S[i] = i;
  let j = 0;
  for (let i = 0; i < 256; i++) {
    j = (j + S[i] + key[i % key.length]) & 0xff;
    [S[i], S[j]] = [S[j], S[i]];
  }
  const out = new Uint8Array(bytes.length);
  let i = 0;
  j = 0;
  for (let n = 0; n < bytes.length; n++) {
    i = (i + 1) & 0xff;
    j = (j + S[i]) & 0xff;
    [S[i], S[j]] = [S[j], S[i]];
    const k = S[(S[i] + S[j]) & 0xff];
    out[n] = bytes[n] ^ k;
  }
  return out;
}

function rc4Encrypt(plainText, keySeed) {
  const plainBytes = new TextEncoder().encode(plainText);
  const outBytes = rc4(plainBytes, keySeed);
  let bin = "";
  outBytes.forEach((b) => (bin += String.fromCharCode(b)));
  return btoa(bin);
}

async function hmacHex(secret, message) {
  const key = await crypto.subtle.importKey(
    "raw", new TextEncoder().encode(secret),
    { name: "HMAC", hash: "SHA-256" }, false, ["sign"]
  );
  const sig = await crypto.subtle.sign("HMAC", key, new TextEncoder().encode(message));
  return [...new Uint8Array(sig)].map((b) => b.toString(16).padStart(2, "0")).join("");
}

function toBase64Url(str) {
  return btoa(str).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

function fromBase64Url(str) {
  let s = str.replace(/-/g, "+").replace(/_/g, "/");
  while (s.length % 4) s += "=";
  return atob(s);
}

// -------------------- Handlers --------------------

// POST /api/auth  { hwid, script }
async function handleAuth(request, env) {
  if (request.method !== "POST") return jsonResponse({ error: "method" }, 405);

  const body = await request.json().catch(() => null);
  const { hwid, script } = body || {};
  if (!hwid || !script) return jsonResponse({ error: "missing_fields" }, 400);
  if (!PROTECTED_SCRIPTS[script]) return jsonResponse({ error: "unknown_script" }, 404);

  const banned = await env.VELZAR_DB.get("ban:" + hwid);
  if (banned) return jsonResponse({ error: "banned" }, 403);

  const payloadStr = JSON.stringify({ script, hwid, ts: Date.now() });
  const payloadB64 = toBase64Url(payloadStr);
  const sig = await hmacHex(env.ADMIN_SECRET, payloadB64);
  const token = payloadB64 + "." + sig;

  return jsonResponse({ token });
}

// GET 
async function handlePayload(request, env) {
  const url = new URL(request.url);
  const token = url.searchParams.get("t");
  if (!token) return jsonResponse({ error: "missing_token" }, 400);

  const dot = token.lastIndexOf(".");
  if (dot === -1) return jsonResponse({ error: "invalid_token" }, 401);
  const payloadB64 = token.slice(0, dot);
  const sig = token.slice(dot + 1);

  const expectedSig = await hmacHex(env.ADMIN_SECRET, payloadB64);
  if (sig !== expectedSig) return jsonResponse({ error: "invalid_token" }, 401);

  let data;
  try {
    data = JSON.parse(fromBase64Url(payloadB64));
  } catch {
    return jsonResponse({ error: "invalid_token" }, 401);
  }

  if (Date.now() - data.ts > 20000) {
    return jsonResponse({ error: "token_expired" }, 401);
  }

  const banned = await env.VELZAR_DB.get("ban:" + data.hwid);
  if (banned) return jsonResponse({ error: "banned" }, 403);

  const kvId = PROTECTED_SCRIPTS[data.script];
  if (!kvId) return jsonResponse({ error: "unknown_script" }, 404);

  const sourceCode = await env.VELZAR_DB.get(kvId);
  if (!sourceCode) return jsonResponse({ error: "script_not_configured" }, 404);

  const watermark = `-- wm:${data.hwid.slice(0, 12)}:${data.ts}\n`;
  const encrypted = rc4Encrypt(watermark + sourceCode, token);

  return jsonResponse({ payload: encrypted });
}

// -------------------- Admin --------------------
function checkAdmin(request, env) {
  const auth = request.headers.get("Authorization") || "";
  return !!env.ADMIN_SECRET && auth === "Bearer " + env.ADMIN_SECRET;
}

// POST 
async function handleAdminScript(request, env) {
  if (!checkAdmin(request, env)) return jsonResponse({ error: "unauthorized" }, 401);
  const { script, source } = await request.json().catch(() => ({}));
  if (!script || !PROTECTED_SCRIPTS[script] || !source) {
    return jsonResponse({ error: "bad_request" }, 400);
  }
  await env.VELZAR_DB.put(PROTECTED_SCRIPTS[script], source);
  return jsonResponse({ ok: true });
}

// POST 
async function handleAdminBan(request, env) {
  if (!checkAdmin(request, env)) return jsonResponse({ error: "unauthorized" }, 401);
  const { hwid, banned } = await request.json().catch(() => ({}));
  if (!hwid) return jsonResponse({ error: "missing_hwid" }, 400);
  if (banned) {
    await env.VELZAR_DB.put("ban:" + hwid, "1");
  } else {
    await env.VELZAR_DB.delete("ban:" + hwid);
  }
  return jsonResponse({ ok: true });
}

// -------------------- Router --------------------

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname.toLowerCase();

    if (path === "/api/auth") return handleAuth(request, env);
    if (path === "/api/payload") return handlePayload(request, env);
    if (path === "/api/admin/script") return handleAdminScript(request, env);
    if (path === "/api/admin/ban") return handleAdminBan(request, env);

    // ----

    const validScripts = ["/test.lua", "/sexyboy-esp.lua", "/blockcopysb.lua", "/otc.lua"];

    if (/\.lua$/i.test(path) && !validScripts.includes(path)) {
      return Response.redirect("https://velzarscripts.pages.dev/", 302);
    }

    if (validScripts.includes(path)) {
      const accept = request.headers.get("Accept") || "";
      const fetchMode = request.headers.get("Sec-Fetch-Mode") || "";
      const isBrowserNavigation = fetchMode === "navigate" || accept.includes("text/html");

      if (isBrowserNavigation) {
        const loader = `loadstring(game:HttpGet("${url.origin}${url.pathname}"))()`;
        const safeLoader = loader
          .replace(/&/g, "&amp;").replace(/</g, "&lt;")
          .replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#39;");

        const html = `<!doctype html><html lang="es"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1"><title>Velzar Scripts</title></head>
<body style="background:#050505;color:#eee;font-family:Arial;display:flex;align-items:center;justify-content:center;min-height:100vh">
<div style="max-width:560px;text-align:center"><h2>VELZAR SCRIPTS</h2>
<pre style="background:#0d0d10;padding:20px;border-radius:12px;white-space:pre-wrap;word-break:break-all">${safeLoader}</pre>
</div></body></html>`;

        return new Response(request.method === "HEAD" ? null : html, {
          status: 200,
          headers: {
            "Content-Type": "text/html; charset=utf-8",
            "Cache-Control": "no-store, no-cache, must-revalidate",
            "X-Content-Type-Options": "nosniff",
            "Referrer-Policy": "no-referrer",
          },
        });
      }

      // 
      return env.ASSETS.fetch(request);
    }

    return env.ASSETS.fetch(request);
  },
};
