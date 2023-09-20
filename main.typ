#import "paper_template.typ": paper
#show: doc => paper(
  // font: "palatino", // "Times New Roman"
  // fontsize: 12pt, // 12pt
  title: [Manual de Instrucciones - Stack ELK], // title 
  authors: (
    (
      name: "Rafael Morales Venegas",
      affiliation: "Universidad Tecnológica Metropolitana",
      email: "rmorales@utem.cl",
      note: "Alumno Tesista 2023",
    ),
  ),
  date: "July 2023",
  abstract: lorem(80), // replace lorem(80) with [ Your abstract here. ]
  keywords: [
    Elastic Stack,
    SISEI,
    Monitoreo de Logs
    Centralización de Logs,
    ],
  JEL: [G11, G12],
  acknowledgements: "This paper is a work in progress. Please do not cite without permission.", // Acknowledgements 
  bibloc: "My Library.bib",
  // bibstyle: "chicago-author-date", // ieee, chicago-author-date, apa, mla
  // bibtitle: "References",
  doc,
)

#set raw(block: true)
// Display inline code in a small box
// that retains the correct baseline.
#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

// Display block code in a larger block
// with more padding.
#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
)

// your main text goes here
#set heading(numbering: "1.")
#set text(spacing: 100%)
#set par(leading: 1.5em)
#set par(
  first-line-indent: 2em,
  justify: true,
)

#include("src/instalacion.typ");
#include("src/first-config.typ");
#include("src/problems.typ");

