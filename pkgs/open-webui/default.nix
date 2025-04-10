{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  ffmpeg,
  python312,
  nixosTests,
}:
let
  pname = "open-webui";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "open-webui";
    repo = "open-webui";
    tag = "v${version}";
    hash = "sha256-vlaJv4CbhjbJbiNZHKsedS2vBXp44oE/7ZALgkPASHI=";
  };

  frontend = buildNpmPackage {
    inherit pname version src;

    npmDepsHash = "sha256-g47tK6BC6CE0hqdZbToQMB5QeNdufhO12xPrAjbfMTk=";

    # Disabling `pyodide:fetch` as it downloads packages during `buildPhase`
    # Until this is solved, running python packages from the browser will not work.
    postPatch = ''
      substituteInPlace package.json \
        --replace-fail "npm run pyodide:fetch && vite build" "vite build"
    '';

    env.CYPRESS_INSTALL_BINARY = "0"; # disallow cypress from downloading binaries in sandbox
    env.ONNXRUNTIME_NODE_INSTALL_CUDA = "skip";
    env.NODE_OPTIONS = "--max-old-space-size=8192";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share
      cp -a build $out/share/open-webui

      runHook postInstall
    '';
  };
in
python312.pkgs.buildPythonApplication rec {
  inherit pname version src;
  pyproject = true;

  # Not force-including the frontend build directory as frontend is managed by the `frontend` derivation above.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', build = "open_webui/frontend"' ""
  '';

  propagatedBuildInputs = [
    ffmpeg
  ];

  env.HATCH_BUILD_NO_HOOKS = true;

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    "docker"
    "pytest"
    "pytest-docker"
  ];

  dependencies = with python312.pkgs; [
    aiocache
    aiofiles
    aiohttp
    alembic
    anthropic
    apscheduler
    argon2-cffi
    async-timeout
    authlib
    bcrypt
    beautifulsoup4
    black
    boto3
    chromadb
    colbert-ai
    docx2txt
    duckduckgo-search
    einops
    extract-msg
    fake-useragent
    fastapi
    faster-whisper
    flask
    flask-cors
    fpdf2
    ftfy
    google-api-python-client
    google-auth-httplib2
    google-auth-oauthlib
    google-generativeai
    googleapis-common-protos
    iso-639
    langchain
    langchain-chroma
    langchain-community
    langdetect
    langfuse
    ldap3
    markdown
    nltk
    openai
    opencv-python-headless
    openpyxl
    (opensearch-py.overridePythonAttrs (old: {
      doCheck = false; # Network tests fail in the sandbox
    }))
    pandas
    passlib
    peewee
    peewee-migrate
    pgvector
    psutil
    psycopg2-binary
    pydub
    pyjwt
    pymdown-extensions
    pymilvus
    pymongo
    pymysql
    pypandoc
    pypdf
    python-dotenv
    python-jose
    python-multipart
    python-pptx
    python-socketio
    pytube
    pyxlsb
    qdrant-client
    rank-bm25
    rapidocr-onnxruntime
    redis
    requests
    sentence-transformers
    soundfile
    tiktoken
    unstructured
    uvicorn
    validators
    xlrd
    youtube-transcript-api
  ];

  build-system = with python312.pkgs; [ hatchling ];

  pythonImportsCheck = [ "open_webui" ];

  makeWrapperArgs = [
    "--set FRONTEND_BUILD_DIR ${frontend}/share/open-webui"
    "--prefix PATH : ${lib.makeBinPath [ ffmpeg ]}"  # Ensure ffmpeg is in PATH
  ];

  passthru = {
    tests = {
      inherit (nixosTests) open-webui;
    };
    updateScript = ./update.sh;
  };

  meta = {
    changelog = "https://github.com/open-webui/open-webui/blob/${src.tag}/CHANGELOG.md";
    description = "Comprehensive suite for LLMs with a user-friendly WebUI";
    homepage = "https://github.com/open-webui/open-webui";
    license = lib.licenses.mit;
    mainProgram = "open-webui";
    maintainers = with lib.maintainers; [
      drupol
      shivaraj-bh
    ];
  };
}
