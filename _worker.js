// ============================================================
// VELZAR SCRIPTS - Proteccion de codigo fuente (sin keys manuales)
// Cloudflare Pages (Advanced Mode) - reemplaza tu _worker.js
// Requiere 1 KV namespace bindeado: VELZAR_DB
// Requiere 1 variable de entorno secreta: ADMIN_SECRET
//
// Como funciona:
// - El loadstring se comparte libre, no hay keys que pedir ni pegar.
// - El .lua publico es solo un stub: pide el codigo real al Worker.
// - El Worker identifica al usuario por HWID automaticamente (primera
//   vez que corre, queda registrado) y le entrega el codigo cifrado
//   con un token que vence en segundos y se usa una sola vez.
// - El codigo real nunca esta en GitHub ni se sirve como archivo estatico.
// - Si alguien filtra un script, la marca de agua te dice que HWID fue,
//   y lo podes banear sin tocar nada del repo.
// ============================================================

// Nombre publico del script -> id interno en KV donde esta el codigo real
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

// ---- RC4: cifrado simetrico, facil de replicar en Lua puro ----
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

// -------------------- Handlers --------------------

// POST /api/auth  { hwid, script }
// No pide key. Si el HWID es nuevo, lo registra solo. Si esta baneado, corta.
async function handleAuth(request, env) {
  if (request.method !== "POST") return jsonResponse({ error: "method" }, 405);

  const body = await request.json().catch(() => null);
  const { hwid, script } = body || {};
  if (!hwid || !script) return jsonResponse({ error: "missing_fields" }, 400);
  if (!PROTECTED_SCRIPTS[script]) return jsonResponse({ error: "unknown_script" }, 404);

  let record = await env.VELZAR_DB.get("hwid:" + hwid, { type: "json" });
  if (!record) {
    record = { createdAt: Date.now(), banned: false };
    await env.VELZAR_DB.put("hwid:" + hwid, JSON.stringify(record));
  }
  if (record.banned) return jsonResponse({ error: "banned" }, 403);

  // Rate limit: max 1 pedido cada 2 segundos por HWID.
  // Cloudflare KV no permite expirationTtl menor a 60s, asi que
  // controlamos el tiempo a mano con una marca de tiempo guardada.
  const now = Date.now();
  const rlRaw = await env.VELZAR_DB.get("rl:" + hwid, { type: "json" });
  if (rlRaw && now - rlRaw.last < 2000) {
    return jsonResponse({ error: "rate_limited" }, 429);
  }
  await env.VELZAR_DB.put("rl:" + hwid, JSON.stringify({ last: now }), { expirationTtl: 60 });

  // Token de un solo uso, vence en 20 segundos (chequeado a mano en /api/payload,
  // el expirationTtl de 60s es solo limpieza de KV, no el vencimiento real).
  const token = randomId(24);
  await env.VELZAR_DB.put(
    "tok:" + token,
    JSON.stringify({ script, hwid, used: false, createdAt: now }),
    { expirationTtl: 60 }
  );

  return jsonResponse({ token });
}

// GET /api/payload?t=TOKEN
async function handlePayload(request, env) {
  const url = new URL(request.url);
  const token = url.searchParams.get("t");
  if (!token) return jsonResponse({ error: "missing_token" }, 400);

  const raw = await env.VELZAR_DB.get("tok:" + token);
  if (!raw) return jsonResponse({ error: "invalid_or_expired_token" }, 401);
  await env.VELZAR_DB.delete("tok:" + token); // un solo uso, se borra ya

  const data = JSON.parse(raw);
  if (Date.now() - data.createdAt > 20000) {
    return jsonResponse({ error: "token_expired" }, 401);
  }
  const kvId = PROTECTED_SCRIPTS[data.script];
  const sourceCode = await env.VELZAR_DB.get(kvId);
  if (!sourceCode) return jsonResponse({ error: "script_not_configured" }, 404);

  // Marca de agua: queda el HWID y el token en un comentario al principio.
  const watermark = `-- wm:${data.hwid.slice(0, 12)}:${token.slice(0, 8)}\n`;
  const encrypted = rc4Encrypt(watermark + sourceCode, token);

  return jsonResponse({ payload: encrypted });
}

// -------------------- Admin --------------------
function checkAdmin(request, env) {
  const auth = request.headers.get("Authorization") || "";
  return !!env.ADMIN_SECRET && auth === "Bearer " + env.ADMIN_SECRET;
}

// POST /api/admin/script  { script, source }  -> sube/actualiza el codigo real
async function handleAdminScript(request, env) {
  if (!checkAdmin(request, env)) return jsonResponse({ error: "unauthorized" }, 401);
  const { script, source } = await request.json().catch(() => ({}));
  if (!script || !PROTECTED_SCRIPTS[script] || !source) {
    return jsonResponse({ error: "bad_request" }, 400);
  }
  await env.VELZAR_DB.put(PROTECTED_SCRIPTS[script], source);
  return jsonResponse({ ok: true });
}

// POST /api/admin/ban  { hwid, banned: true|false }  -> banear/desbanear un HWID
async function handleAdminBan(request, env) {
  if (!checkAdmin(request, env)) return jsonResponse({ error: "unauthorized" }, 401);
  const { hwid, banned } = await request.json().catch(() => ({}));
  if (!hwid) return jsonResponse({ error: "missing_hwid" }, 400);
  let record = (await env.VELZAR_DB.get("hwid:" + hwid, { type: "json" })) || { createdAt: Date.now() };
  record.banned = !!banned;
  await env.VELZAR_DB.put("hwid:" + hwid, JSON.stringify(record));
  return jsonResponse({ ok: true, record });
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

    // ---- tu logica original para servir los .lua y la pagina HTML ----

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

      // El executor (o quien se haga pasar por uno) recibe solo el stub.
      return env.ASSETS.fetch(request);
    }

    return env.ASSETS.fetch(request);
  },
};
