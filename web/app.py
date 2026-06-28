#!/usr/bin/env python3
import html
import os
import subprocess
from datetime import datetime
from pathlib import Path
from flask import Flask, render_template, request

BASE_DIR = Path(__file__).resolve().parents[1]
TEST_DIR = BASE_DIR / "testes"

app = Flask(__name__)

def run_cmd(cmd, env=None, timeout=30):
    merged_env = os.environ.copy()
    if env:
        merged_env.update(env)
    try:
        result = subprocess.run(
            cmd,
            cwd=str(BASE_DIR),
            env=merged_env,
            text=True,
            capture_output=True,
            timeout=timeout,
            check=False,
        )
        return {
            "cmd": " ".join(cmd),
            "rc": result.returncode,
            "stdout": result.stdout,
            "stderr": result.stderr,
        }
    except subprocess.TimeoutExpired as exc:
        return {
            "cmd": " ".join(cmd),
            "rc": 124,
            "stdout": exc.stdout or "",
            "stderr": f"Timeout após {timeout}s",
        }

@app.route("/", methods=["GET"])
def index():
    return render_template("index.html")

@app.route("/validar", methods=["POST"])
def validar():
    env = {
        "SMTP_HOST": request.form.get("smtp_host", "smtp.exemplo.com").strip(),
        "SMTP_PORT": request.form.get("smtp_port", "25").strip(),
        "TLS_MODE": request.form.get("tls_mode", "starttls").strip(),
        "MAIL_FROM": request.form.get("mail_from", "naoresponda@exemplo.com").strip(),
        "TEST_TO": request.form.get("test_to", "destino@exemplo.com").strip(),
    }

    testes = [
        ("DNS", [str(TEST_DIR / "testar-dns.sh")]),
        ("Conectividade", [str(TEST_DIR / "testar-conectividade.sh")]),
        ("TLS", [str(TEST_DIR / "testar-openssl.sh")]),
        ("Fila", [str(TEST_DIR / "testar-fila.sh")]),
    ]

    resultados = []
    for nome, cmd in testes:
        resultados.append((nome, run_cmd(cmd, env=env, timeout=40)))

    return render_template("resultado.html", resultados=resultados, env=env, agora=datetime.now())

@app.route("/logs", methods=["GET"])
def logs():
    resultado = run_cmd(["journalctl", "-u", "postfix", "-n", "120", "--no-pager"], timeout=15)
    return render_template("logs.html", resultado=resultado)

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=8080)
