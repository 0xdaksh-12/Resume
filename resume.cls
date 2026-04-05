\ProvidesClass{resume}[2010/07/10 v0.9 Resume class]

\LoadClass[11pt,letterpaper]{article}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
\usepackage{array}
\usepackage{ifthen}
\pagestyle{empty}

% ---------- Name ----------
\def \name#1{\def\@name{#1}}
\def \@name {}

% ---------- Address (up to 3 lines) ----------
\def \addressSep {$\diamond$}
\let \@addressone   \relax
\let \@addresstwo   \relax
\let \@addressthree \relax

\def \address #1{
  \@ifundefined{@addresstwo}{
    \def \@addresstwo {#1}
  }{
    \@ifundefined{@addressthree}{
      \def \@addressthree {#1}
    }{
      \def \@addressone {#1}
    }
  }
}

\def \printaddress #1{
  \begingroup
    \def \\ {\addressSep\ }
    \centerline{#1}
  \endgroup
  \par
  \addressskip
}

\def \printname {
  \begingroup
    \hfil{\MakeUppercase{\namesize\bf \@name}}\hfil
    \nameskip\break
  \endgroup
}

% ---------- Bootstrap the document ----------
\let\ori@document=\document
\renewcommand{\document}{
  \ori@document
  \printname
  \@ifundefined{@addressone}{}{\printaddress{\@addressone}}
  \@ifundefined{@addresstwo}{}{\printaddress{\@addresstwo}}
  \@ifundefined{@addressthree}{}{\printaddress{\@addressthree}}
}

% ---------- rSection ----------
\newenvironment{rSection}[1]{
  \sectionskip
  \MakeUppercase{\bf #1}
  \sectionlineskip
  \hrule
  \begin{list}{}{
    \setlength{\leftmargin}{1.5em}
  }
  \item[]
}{
  \end{list}
}

% ---------- rSubsection ----------
\newenvironment{rSubsection}[4]{
  {\bf #1} \hfill {#2}
  \ifthenelse{\equal{#3}{}}{}{
    \\
    {\em #3} \hfill {#4}
  }
  \begin{list}{$\cdot$}{\leftmargin=0em}
  \itemsep -0.5em \vspace{-0.5em}
}{
  \end{list}
  \vspace{0.5em}
}

% ---------- Spacing ----------
\def\namesize{\huge}
\def\nameskip{\smallskip}
\def\addressskip{\vskip 2pt}
\def\sectionskip{\smallskip}
\def\sectionlineskip{\smallskip}
