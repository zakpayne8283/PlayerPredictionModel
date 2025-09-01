#!/bin/bash

# Do the R stuff
Rscript src/data/setup_data.R

# Optional: Activate virtualenv
if [ -d ".venv" ]; then
    source .venv/Scripts/activate
else
    echo "⚠️  No .venv found. Did you run setup.sh?"
    exit 1
fi

# Pass all CLI args to Python entry point
python src/main.py "$@"