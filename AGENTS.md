# Working on this repository

A LaTeX CV built with XeLaTeX and the Awesome-CV class. One set of content
builds into several PDFs ("variants"); each variant can show different
bullets, a different headline and a different section order.

## Where things are

- `variants/<name>.tex`: one file per PDF. Sets the paper size, defines
  `\cvvariant` as its own file name, and calls the section commands in order.
  A new file here becomes a new build target automatically.
- `content/sections.tex`: defines `\cvHeader`, `\cvSummary`, `\cvExperience`,
  `\cvEducation`, `\cvProjects`, `\cvSkills`, and which entry files each one
  includes, in order. Newest entries first.
- `content/profile.tex`: name, headline (`\position`), contact details.
- `content/summary.tex`: plain paragraph, no markup needed.
- `content/<section>/<entry>.tex`: one `\cventry` per file.
- `content/skills/*.tex`: `\cvskill{label}{items}` rows.
- `styles/theme.tex`: colour, margins, header alignment, gaps, text sizes.
  Visual changes go here first.
- `styles/layout.tex`: overrides of Awesome-CV environments (bullet lists,
  skills table, section rule, paragraph).
- `styles/variants.tex`: `\ifvariant`, `\onlyin`, `\except`.
- `awesome-cv.cls`: the upstream class. Don't edit it; override in `styles/`.

## Commands

- `make check` builds everything and fails if any variant is longer than one
  page. It also prints overfull lines and characters missing from the fonts.
  Run it after every change and fix what it reports.
- `make <variant>` builds a single variant into `dist/<variant>.pdf`.
- `make previews` re-renders `docs/<variant>.png`, the images in the README.
  Run it when the sample content or the look changes, and look at the images
  to confirm the result.

## Rules

1. Every variant fits on one page. When something no longer fits, cut or
   shorten the weakest bullets first; tighten spacing in `styles/theme.tex`
   only after that, and keep body text at 9pt or more.
2. Facts are written once. Employers, titles, dates and numbers live in the
   shared entry files; variants differ only in which bullets they show,
   wording, and order.
3. Never invent achievements, numbers, skills or dates. If a bullet needs a
   figure the user hasn't given, ask for it or leave the figure out.
4. No blank lines inside `\cventry` arguments. `\cventry` is a short command,
   so a blank line ends the build with "Paragraph ended before \cventry was
   complete".
5. Escape `% & $ # _` in text. Use `--` for date ranges, `\textbf{}` and
   `\textit{}` for emphasis, `\href{url}{text}` for links.
6. Wrap whole `\item`s in variant commands, not half sentences.
7. Bullets start with a verb, past tense for past roles and present tense for
   the current one, and fit on one or two lines.

## How to

**Add an entry.** Copy a file in the right `content/` folder, fill in the five
arguments, then add `\cventrygap` and `\input{...}` for it in
`content/sections.tex` at the right place in date order. Argument order:

```latex
\cventry
  {role or degree}        % small grey line
  {organisation}          % bold line
  {location}              % may be empty: {}
  {dates}                 % e.g. Mar. 2024 -- Present
  {description}           % a cvitems list or one plain sentence
```

**Show something in some variants only.** `\onlyin{a,b}{...}`,
`\except{a}{...}` or `\ifvariant{a}{shown in a}{shown elsewhere}`. They also
work inside the skills table. For section titles, wrap the whole
`\cvsection{...}` rather than putting the condition inside it.

**Add a variant.** Copy `variants/industry.tex` to `variants/<name>.tex`, set
`\newcommand{\cvvariant}{<name>}`, reorder or remove section calls, then add
`\onlyin{<name>}{...}` where the content should differ. Nothing else needs
registering; the Makefile and the workflow glob `variants/*.tex`.

**Add a section.** Define a command in `content/sections.tex` following the
existing ones (`cventries` for entries, `cvparagraph` for free text,
`cvskills` for label/value rows), then call it from the variant files that
should show it.

**Tailor to a job description.** Prefer a new variant over editing an existing
one. Adjust the headline with `\ifvariant` in `content/profile.tex`, pick and
reorder bullets with `\onlyin`, and reorder sections. Reword only to match the
posting's vocabulary where it's still accurate (rule 3).

**Change the look.** Accent colour: `\definecolor{awesome}{HTML}{......}` in
`styles/theme.tex`. Header font is Roboto from `fonts/` (`\headerfont`,
`\headerfontlight`); body font is Source Sans (`\bodyfont`, `\bodyfontlight`).
To swap a font, declare it with `\newfontfamily` in `styles/theme.tex` and
`\renewcommand*` the matching command. Per-element sizes and colours are the
`\...style` commands listed in `awesome-cv.cls`; override them in
`styles/theme.tex`.

**Rename the released PDFs.** `PDF_NAME` in `.github/workflows/build.yml`.
