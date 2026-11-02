#import "@preview/touying:0.8.0": *
#import themes.metropolis: *
#import "@preview/numbly:0.1.0": numbly

#set text(
  font: "Fira Sans",
  weight: "light",
  size: 20pt,
)
#show raw: set text(font: "FiraCode Nerd Font Mono")

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  // catppuccin latte
  config-colors(
    primary: rgb("#dc8a78"),
    primary-light: rgb("#dc8a78"),
    secondary: rgb("#dd7878"),
    neutral-lightest: rgb("#eff1f5"),
    neutral-dark: rgb("#5c5f77"),
    neutral-darkest: rgb("#4c4f69"),
  ),
  // align: horizon,
  // config-common(handout: true),
  config-info(
    title: [],
    subtitle: [],
    author: [Kei Tang],
    date: datetime.today(),
    institution: [Recurse Center],
    // contact: [contact\@mail.com],
    logo: emoji.octopus,
  ),
  config-common(new-section-slide-fn: none)
)

#set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()
