# GardenAI Documentation

This folder contains the detailed GardenAI documentation. The top-level
`README.md` remains the short entry point for the repository.

## Contents

- [Windows setup](windows-setup.md): local setup for Windows using PowerShell,
  Command Prompt, and `.env` options.
- [Docker setup](docker-setup.md): build, run, and troubleshoot the container.
- [Architecture](architecture.md): application structure, runtime flow, and
  Mermaid diagrams.
- [Usage guide](usage.md): supported inputs, expected behavior, and examples.
- [Development notes](development.md): repository layout, validation checks,
  dependency notes, and common maintenance tasks.

## Application Summary

GardenAI is a Streamlit chat application. It accepts garden preferences from a
user, asks OpenAI to extract structured garden information through tool calls,
filters the local native plant CSV, and then asks OpenAI to format the matching
plant list for the user.

The current dataset is stored at `data/native_plants_AL_MI_v_1.csv` and covers
native plants for Alabama and Michigan.
