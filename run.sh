#!/bin/bash

# Notice: this file was heavily built with GPT

set -e  # exit if any command fails

USE_CACHE=false

# Parse arguments
for arg in "$@"; do
  case $arg in
    --use-cache)
      USE_CACHE=true
      shift
      ;;
    *)
      # ignore other args or handle them if you want
      ;;
  esac
done

# Run setup_data.R unless --use-cache was passed
if [ "$USE_CACHE" = false ]; then
  echo "Running setup_data.R..."
  Rscript src/data/setup_data.R
else
  echo "Skipping setup_data.R (using cache)."
fi

# Optional: Activate virtualenv
if [ -d ".venv" ]; then
    source .venv/Scripts/activate
else
    echo "⚠️  No .venv found. Did you run setup.sh?"
    exit 1
fi

# Pass all CLI args to Python entry point
python src/main.py "$@"