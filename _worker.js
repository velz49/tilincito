
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname.toLowerCase();

    // ÚNICOS SCRIPTS AUTORIZADOS
    const validScripts = [
      "/test.lua",
      "/sexyboy-esp.lua",
      "/blockcopysb.lua",
      "/otc.lua"
    ];

    // Si la URL termina en .lua pero no está autorizada,
    // volver a la página principal.
    if (/\.lua$/i.test(path) && !validScripts.includes(path)) {
      return Response.redirect(
        "https://velzarscripts.pages.dev/",
        302
      );
    }

    if (validScripts.includes(path)) {
      const accept = request.headers.get("Accept") || "";
      const fetchMode = request.headers.get("Sec-Fetch-Mode") || "";

      const isBrowserNavigation =
        fetchMode === "navigate" || accept.includes("text/html");

      if (isBrowserNavigation) {
        // Confirmar que el archivo realmente exista.
        const assetResponse = await env.ASSETS.fetch(request);

        if (!assetResponse.ok) {
          return Response.redirect(
            "https://velzarscripts.pages.dev/",
            302
          );
        }

        const loader =
          `loadstring(game:HttpGet("${url.origin}${url.pathname}"))()`;

        const safeLoader = loader
          .replace(/&/g, "&amp;")
          .replace(/</g, "&lt;")
          .replace(/>/g, "&gt;")
          .replace(/"/g, "&quot;")
          .replace(/'/g, "&#39;");

        const html = `<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Velzar Scripts</title>
<style>
*{box-sizing:border-box}
body{
  margin:0;min-height:100vh;padding:24px;
  display:flex;align-items:center;justify-content:center;
  background:#050505;color:#f5f5f5;
  font-family:Arial,sans-serif
}
.container{width:100%;max-width:560px}
.brand{
  margin-bottom:18px;text-align:center;
  font-size:22px;font-weight:800;letter-spacing:3px
}
.brand span{color:#a855f7}
.subtitle{
  margin:0 0 22px;text-align:center;
  color:#777;font-size:13px
}
.code-card{
  overflow:hidden;border:1px solid #29202f;
  border-radius:16px;background:#0d0d10;
  box-shadow:0 0 28px #a855f714
}
.card-header{
  display:flex;align-items:center;gap:7px;
  padding:14px 16px;border-bottom:1px solid #242027;
  color:#999;font-size:12px
}
.dot{width:8px;height:8px;border-radius:50%;background:#a855f7}
pre{
  margin:0;padding:22px 18px;overflow-wrap:anywhere;
  white-space:pre-wrap;color:#d8b4fe;
  font:13px/1.8 Consolas,monospace
}
.card-footer{display:flex;justify-content:center;padding:0 16px 16px}
.copy-button{
  display:flex;align-items:center;justify-content:center;gap:9px;
  min-width:130px;padding:10px 16px;
  border:1px solid #3b2a49;border-radius:10px;
  background:#17121d;color:#eee;font-size:13px;cursor:pointer
}
.copy-button:hover{background:#251630;border-color:#a855f7}
.copy-button svg{
  width:17px;height:17px;fill:none;stroke:currentColor;
  stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round
}
.copy-button.copied{color:#d8b4fe;border-color:#a855f7}
.footer-text{
  margin-top:18px;text-align:center;color:#555;
  font-size:11px;letter-spacing:1px
}
</style>
</head>
<body>
<main class="container">
  <div class="brand">VELZAR <span>SCRIPTS</span></div>
  <p class="subtitle">Script access</p>
  <section class="code-card">
    <div class="card-header"><span class="dot"></span><span>LOADSTRING</span></div>
    <pre id="loader">${safeLoader}</pre>
    <div class="card-footer">
      <button class="copy-button" id="copyButton" type="button">
        <svg viewBox="0 0 24 24" aria-hidden="true">
          <rect x="8" y="8" width="12" height="12" rx="2"></rect>
          <path d="M16 8V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h3"></path>
        </svg>
        <span id="copyLabel">Copiar código</span>
      </button>
    </div>
  </section>
  <div class="footer-text">VELZAR SCRIPTS · OFFICIAL</div>
</main>
<script>
const loader = ${JSON.stringify(loader)};
const button = document.getElementById("copyButton");
const label = document.getElementById("copyLabel");

button.addEventListener("click", async () => {
  try {
    await navigator.clipboard.writeText(loader);
    label.textContent = "¡Copiado!";
    button.classList.add("copied");
  } catch (error) {
    const area = document.createElement("textarea");
    area.value = loader;
    area.style.position = "fixed";
    area.style.opacity = "0";
    document.body.appendChild(area);
    area.select();
    const success = document.execCommand("copy");
    area.remove();
    label.textContent = success ? "¡Copiado!" : "No se pudo copiar";
    if (success) button.classList.add("copied");
  }

  setTimeout(() => {
    label.textContent = "Copiar código";
    button.classList.remove("copied");
  }, 1800);
});
</script>
</body>
</html>`;

        return new Response(
          request.method === "HEAD" ? null : html,
          {
            status: 200,
            headers: {
              "Content-Type": "text/html; charset=utf-8",
              "Cache-Control": "no-store, no-cache, must-revalidate",
              "X-Content-Type-Options": "nosniff",
              "Referrer-Policy": "no-referrer"
            }
          }
        );
      }

      // Para el executor, entregar el Lua original.
      return env.ASSETS.fetch(request);
    }

    // Mantener el sitio principal funcionando normalmente.
    return env.ASSETS.fetch(request);
  }
};

