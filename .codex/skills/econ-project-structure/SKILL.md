---
name: econ-project-structure
description: Use when working in this project and a strict folder layout is required for dofiles, data files, graphs, figures, tables, LaTeX files, and PDFs. Enforces that dofiles go in \dofiles, data files go in \data, graphs/figures/tables go in \output\results, and LaTeX/PDF drafts go in \output\draft.
---

# Economics Project Structure

Apply these rules to every file created or moved in this project.

## Required layout

- Every Stata dofile must be placed in `\dofiles`.
- Every data file must be placed in `\data`.
- All graphs, figures, and tables must be placed in `\output\results`.
- All LaTeX files and PDF files must be placed in `\output\draft`.

## Working rules

- Before creating a file, check that the destination folder follows this structure.
- If a file is generated in the wrong location, move it to the correct folder.
- When writing code that exports outputs, set the export path so files are saved directly in the required folder.
- Keep filenames descriptive and consistent with the project content.

## Default behavior

- If `\dofiles`, `\data`, `\output\results`, or `\output\draft` do not exist, create them before saving files.
- Do not leave graphs, tables, PDFs, or LaTeX files in the project root unless the user explicitly requests an exception.
