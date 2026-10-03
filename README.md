# CV template

A one-page LaTeX CV that builds into several versions from the same content.
Built on [Awesome-CV](https://github.com/posquit0/Awesome-CV) by Claud D. Park.

<p align="center">
  <img src="docs/industry.png" width="49%" alt="Industry variant of the sample CV">
  <img src="docs/research.png" width="49%" alt="Research variant of the sample CV">
</p>

Both pages come from the same files. The left one is the `industry` variant
and the right one is `research`: same jobs, dates and numbers, but a different
headline, different bullet points and a different section order.

## Why use it

**One set of facts, several CVs.** Each job, degree and project lives in one
small file. Variants choose which bullets to show and in what order, so a new
date or a corrected number is written once and appears in every version.
Without this, you end up with `CV_final_v3_research.docx` and a typo fixed in
two copies out of four.

**Your CV has a history.** It's plain text in git, so you can see what
changed between the version you sent in March and today, or go back to it.

**Problems show up before a recruiter sees them.** `make check` fails if a
version spills onto a second page and lists lines that run into the margin.
GitHub builds the PDFs on every push with current TeX Live and publishes them
at a fixed link that always serves the latest version.

**Made to be edited by coding agents.** The files are small and predictable,
`AGENTS.md` sets the rules (one page, facts written once, nothing invented),
and there are ready-made workflows to import an existing CV, add content from
a repository or web page, and tailor a version to a job posting. Entries can
note where their facts came from, so a claim can be checked later.

## When it's not the right tool

- If you update your CV once a year and send the same version everywhere, a
  document editor is less work.
- You need a TeX installation (a few GB), or you edit on GitHub and let the
  workflow build. LaTeX error messages can be cryptic, although `make check`
  and an agent usually get you past them.
- The design is Awesome-CV's. Colours, spacing and sizes are easy to change;
  a completely different layout is real LaTeX work.
- The PDF contains real, selectable text, but no template can promise how
  every applicant tracking system will parse it. Paste the PDF's text into a
  plain editor once to check it reads in a sensible order.
- A public repository means a public CV, including the released PDFs. If
  yours has your phone number or address, make the repository private.

## Getting started

1. Click **Use this template** on GitHub (choose private if your CV will have
   personal details), or clone the repository.
2. Install a TeX distribution with XeLaTeX and latexmk: MacTeX on macOS,
   TeX Live on Linux, MiKTeX on Windows.
3. Run `make`. The PDFs end up in `dist/`.

If you'd rather not install TeX, just push. The workflow in
`.github/workflows/build.yml` builds every variant and attaches the PDFs to a
release called `latest`, so these links always point at the newest version:
[industry](../../releases/latest/download/CV-industry.pdf),
[research](../../releases/latest/download/CV-research.pdf).
Change `PDF_NAME` in the workflow to get file names like
`Jane_Doe_CV-industry.pdf`.

## Examples

The commands below are for [Claude Code](https://claude.com/claude-code),
where the workflows in `.claude/skills/` show up as slash commands. With
another agent, point it at the file instead, for example: "Follow
`.claude/skills/cv-import/SKILL.md` with `inbox/cv.pdf`."

`inbox/` is the place for source material: your old CV, saved job postings,
notes. Git ignores everything in it.

**Move your current CV in.** Save it as a PDF (LinkedIn's "Save to PDF"
export works too), put it in `inbox/` and run:

```
/cv-import inbox/cv.pdf
```

The agent lists what it found before writing anything, asks about unclear
dates, keeps your wording, replaces the sample person, builds, and tells you
if the result runs past one page. Improvements are suggested separately
rather than slipped into the import.

**Add a project from a repository.**

```
/cv-update https://github.com/you/fraud-detector add it to Projects, research variant only
```

It reads the README, results files and your commit history, writes the entry
with numbers only where the repository states them, and notes the sources at
the top of the file. It asks you for your role and dates if the repository
doesn't make them clear.

**Revise an entry from notes or a web page.**

```
/cv-update inbox/q3-notes.md update my current job with the launch
/cv-update https://example.com/product use this for the one-line description of my current employer
```

**Tailor a version to a job posting.**

```
/cv-tailor https://jobs.example.com/ml-engineer acme
```

This creates `variants/acme.tex` and `dist/acme.pdf`: the most relevant
bullets first, the posting's vocabulary where it's accurate, and a table of
requirements against your CV. Gaps come back as questions ("Have you used
Kubernetes? Where?"), not as new claims.

**Small changes in plain language.**

- "Add my new job at Contoso from March 2025 with three bullets, and drop the
  internship from the industry CV."
- "Make a `data` variant that leads with projects and has no summary."
- "Switch to a dark green accent and left-align the header."

Whichever agent made the change, read the PDF yourself before you send it.

## Making it yours by hand

| File | What's in it |
| --- | --- |
| `content/profile.tex` | Name, headline, contact details |
| `content/summary.tex` | The short paragraph at the top of the industry CV |
| `content/experience/`, `education/`, `projects/` | One file per entry |
| `content/skills/` | Rows of the skills table |
| `content/sections.tex` | Which entries go in each section, and in what order |
| `variants/*.tex` | One file per PDF: paper size and section order |
| `styles/theme.tex` | Colours, margins, spacing, text sizes |

Start with `profile.tex`, then replace the sample entries. To add a job, copy
one of the files in `content/experience/`, edit it, and add an `\input` line
for it in `content/sections.tex`. An entry looks like this:

```latex
\cventry
  {Machine Learning Engineer}                 % role
  {Northwind Analytics}                       % organisation
  {Remote}                                    % location
  {Mar. 2024 -- Present}                      % dates
  {
    \begin{cvitems}
      \item {Shown in every variant.}
      \onlyin{industry}{
      \item {Only in the industry CV.}
      }
    \end{cvitems}
  }
```

Two things trip people up: a blank line inside `\cventry` breaks the build,
and `%`, `&`, `$`, `#` and `_` need a backslash in front of them.

## Variants

Each file in `variants/` produces one PDF with the same name. It sets
`\cvvariant` and lists the sections in the order you want:

```latex
\documentclass[11pt,a4paper]{awesome-cv}
\newcommand{\cvvariant}{industry}
\input{content/sections.tex}

\begin{document}
\cvHeader
\cvSummary
\cvExperience
\cvSkills
\cvProjects
\cvEducation
\end{document}
```

The content files then decide what each variant shows:

| Command | Text appears |
| --- | --- |
| `\onlyin{research}{...}` | only in `research` |
| `\except{research}{...}` | everywhere except `research` |
| `\ifvariant{research}{A}{B}` | A in `research`, B everywhere else |

All three take a comma-separated list too, e.g. `\onlyin{research,academic}{...}`.

To add a third version, say for data engineering roles, copy
`variants/industry.tex` to `variants/data.tex`, set `\cvvariant` to `data` and
reorder the sections. `make` and the workflow pick it up without further
changes.

## Changing the look

Most settings are in `styles/theme.tex`, each with a short comment:

- accent colour (Awesome-CV's built-in palette is listed there),
- margins,
- header alignment: left, centre or right,
- space between entries and between sections,
- text sizes.

Paper size is the `a4paper` option in each variant file; use `letterpaper`
for US Letter.

`styles/layout.tex` holds the structural changes to Awesome-CV: list spacing,
the skills table, section rules. `awesome-cv.cls` itself is an unmodified copy
of upstream, so it stays easy to compare or update.

## Commands

| Command | Does |
| --- | --- |
| `make` | Builds every variant into `dist/` |
| `make industry` | Builds one variant |
| `make check` | Builds, then fails if a variant runs past one page. Also lists lines that stick out into the margin |
| `make watch VARIANT=research` | Rebuilds on every save |
| `make previews` | Regenerates the images in `docs/` |
| `make clean` | Removes `dist/` |

Going for two pages? `make check MAX_PAGES=2`.

## Credits

- Design and class file: [Awesome-CV](https://github.com/posquit0/Awesome-CV)
  by Claud D. Park ([@posquit0](https://github.com/posquit0)), released under
  the LaTeX Project Public License 1.3c. `awesome-cv.cls` is an unmodified
  copy of upstream commit
  [`af2d81a`](https://github.com/posquit0/Awesome-CV/blob/af2d81a11548ea0c13ac701d19851d09f539b4fd/awesome-cv.cls).
  This repository splits the content into variants and adjusts spacing and
  sizes in `styles/`; the look is Awesome-CV's. The sample CV is made up and
  is not based on the author's own resume.
- Fonts in `fonts/`: Roboto by Google (Apache 2.0) and Font Awesome 4 by Dave
  Gandy (SIL Open Font License 1.1). Their licences are in the same folder.
  Body text is set in Source Sans by Adobe, which comes with TeX Live and
  MacTeX.

## Licence

- `awesome-cv.cls` and the files in `styles/`, which adapt parts of it, are
  under the [LaTeX Project Public License 1.3c](https://www.latex-project.org/lppl/lppl-1-3c/).
  If you change them and share the result, keep their headers and say what
  you changed.
- The fonts in `fonts/` are under their own licences, included there.
- Everything else is MIT, see [LICENSE](LICENSE).
