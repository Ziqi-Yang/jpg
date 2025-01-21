[private, no-cd, doc("init python virtual env")]
jpg-python-venv-init dir:
  cd '{{dir}}' && python -m venv .venv
