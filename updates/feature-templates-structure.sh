#!/bin/bash
# Script to set up the feature templates structure for Costume Scheduler

# Base directory
BASE_DIR=$(pwd)
FRONTEND_DIR="$BASE_DIR/frontend"
TEMPLATES_DIR="$FRONTEND_DIR/templates"
FEATURE_DIR="$TEMPLATES_DIR/feature"

# Create feature directory
mkdir -p "$FEATURE_DIR"

# Copy existing templates from test to feature
echo "Copying templates from test to feature directory..."

# Create feature directory if it doesn't exist
if [ ! -d "$FEATURE_DIR" ]; then
    mkdir -p "$FEATURE_DIR"
    echo "Created feature directory at $FEATURE_DIR"
fi

# Copy Gantt template
if [ -f "$TEMPLATES_DIR/test/gantt.html" ]; then
    cp "$TEMPLATES_DIR/test/gantt.html" "$FEATURE_DIR/"
    echo "Copied gantt.html to feature directory"
else
    echo "Warning: test/gantt.html not found"
fi

# Copy Extended Overlap template
if [ -f "$TEMPLATES_DIR/test/extended_overlap.html" ]; then
    cp "$TEMPLATES_DIR/test/extended_overlap.html" "$FEATURE_DIR/"
    echo "Copied extended_overlap.html to feature directory"
else
    echo "Warning: test/extended_overlap.html not found"
fi

# Copy Wardrobe Editor template
if [ -f "$TEMPLATES_DIR/test/wardrobe_editor.html" ]; then
    cp "$TEMPLATES_DIR/test/wardrobe_editor.html" "$FEATURE_DIR/"
    echo "Copied wardrobe_editor.html to feature directory"
else
    echo "Warning: test/wardrobe_editor.html not found"
fi

# Create reports.html in feature directory
if [ -f "$TEMPLATES_DIR/reports.html" ]; then
    cp "$TEMPLATES_DIR/reports.html" "$FEATURE_DIR/"
    echo "Copied reports.html to feature directory"
else
    echo "Warning: reports.html not found"
fi

echo "Feature templates structure setup complete"
