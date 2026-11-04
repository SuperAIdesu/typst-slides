#import "@preview/touying:0.8.0": *
#import themes.metropolis: *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/rubby:0.10.2": get-ruby

#let ruby = get-ruby(
  size: 0.5em,         // Ruby font size
  dy: 0pt,             // Vertical offset of the ruby
  pos: top,            // Ruby position (top or bottom)
  alignment: "center", // Ruby alignment ("center", "start", "between", "around")
  delimiter: "|",      // The delimiter between words
  auto-spacing: true,  // Automatically add necessary space around words
)

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
    title: [The weird and wonderful world of CJK fonts],
    subtitle: [A borderline non-programming talk],
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

= Intro

#focus-slide[
  Let's first look at some CJK-related computer errors
]

== Encoding errors

#block(width: 700pt, height: 300pt, stroke: 0pt + gray)[
  #place(center + horizon, dx: 0pt)[
    #image("imgs/npt/cjk_encoding_error_1.png", width: 600pt)
  ]
  #pause
  #place(center + horizon, dx: 0pt, dy: 0pt)[
    #image("imgs/npt/cjk_encoding_error_2.png", width: 700pt)
  ]
  #pause
  #place(center + horizon, dx: 0pt, dy: 0pt)[
    #image("imgs/npt/cjk_encoding_error_3.png", width: 700pt)
  ]#footnote[Cause: Reading UTF-8 as GBK/Reading GBK as UTF-8/Read GBK as UTF-8, save and read again as GBK]
]

== Font errors

#block(width: 700pt, height: 300pt, stroke: 0pt + gray)[
  #place(center + horizon, dx: 0pt)[
    #image("imgs/npt/cjk_square.jpg", width: 650pt)
  ]#footnote[Missing CJK font (on linux)]
  #pause
  #place(center + horizon, dx: 0pt, dy: 0pt)[
    #image("imgs/npt/cjk_missing.png", width: 400pt)
  ]#footnote[Using Japanese font for Chinese, which has a limited set of characters]
]

== A bit of personal context


#cols(columns: (2fr, 1fr), gutter: 1em, lazy-layout: true)[
  #block[
    Unfortunately I have struggled with all of the above errors during my life tinkering with computers `(╥﹏╥)`

    Why?

    - My native language is (Simplified) Chinese
    - I also read/write in Traditional Chinese and Japanese
    - I want text from all those languages display correctly and beautifully:
      - on Linux systems and e-readers
      - on my personal website
      - on graphics software (eg. Illustrator)
  ]
][
  #block(fill: rgb(223, 142, 29, 40), inset: 12pt, radius: 6pt)[
    #align(horizon)[
      / CJK characters: Graphemes used in the *Chinese, Japanese, and Korean* writing systems, which each include Chinese characters (#text(font: "Noto Sans CJK SC")[汉字]/#text(font: "Noto Sans CJK TC")[漢字]).
    ]
  ]
]

= The different language variants

#focus-slide[
  Why are CJK fonts so complex (and sometimes annoying)?
]

== A bit of regional history

Before the 20th century, almost all regions in eastern Asia use Traditional Chinese characters. In the 20th century, different governments made different changes to the writing system#footnote[Mostly to boost public literacy, but sometimes with political motives].
- *(Mainland) China*: In the 1950s, Simplified Chinese is legally standardized, outlawing the old Traditional characters#footnote[The same simplified character set is also the standard in Singapore and Malaysia.].
- *Taiwan*: Traditional Chinese remains the standard.
- *Hong Kong/Macao*: Traditional Chinese remains popular, but with style differences.
- *Japan*: In 1946 and 1981, government published a limited set of standard Chinese characters, some of them are simplified.
- *Korea*: Since 1970s, Chinese characters are not part of the education, and rarely used in daily life.

== CJK regional variants

#align(center)[
  #image("imgs/npt/cjk_variants.png", width: 600pt)
]

== Road to a unified character set

#cols(columns: (5fr, 4fr), gutter: 0em, lazy-layout: true)[
In the early days of computing, _different encoding standards_ were proposed, making it very hard to share documents (and leading to the chaotic encoding errors).

- During the formation of the Unicode standard, *Han unification* was adopted. Different regional glyphs are generally considered to be the same "grapheme", and assigned to a single unicode character#footnote[However many characters were not unified due to compatibility reasons, and it's complicated].
- So, it's now _the font's_ job to display those different regional variants!
][
  #image("imgs/npt/cjk_unicode.svg", width: 350pt)
]

= Interlude

#focus-slide[
  Interlude:

  Vertical or horizontal writing?
]

== For CJK, it's complicated (again)

#cols(columns: (5fr, 4fr), gutter: 1em, lazy-layout: true)[
- Generally speaking, regions that use _Traditional_ characters also use _vertical_ writing (for books), including Taiwan and Japan.
- However, horizontal writing is becoming more common, because it's easier to mix with Latin words and has better software support.
- Since 2011, CSS has support for vertical writing, but almost all websites still use horizontal writing.
][
  #image("imgs/npt/vertical_horizontal.png", width: 300pt)
]

= Fonts

#focus-slide[
  Now let's talk about fonts
]

== CJK font basics

#cols(columns: (5fr, 4fr), gutter: 0em, lazy-layout: true)[
  Similar to English, there are several main typeface styles:

  #v(0.5em)

  - Sans-serif: #text(font: "Noto Sans CJK SC")[#ruby[Simplified][黑体]]/#text(font: "Noto Sans CJK TC")[#ruby[Traditional][黑體]]/#text(font: "Noto Sans CJK JP")[#ruby[Japanese][ゴシック体]] ("Gothic" or "Black")
  - #text(font: "Noto Serif")[Serif]: #text(font: "Noto Serif CJK SC")[宋体]/#text(font: "Noto Serif CJK TC")[明體]/#text(font: "Noto Serif CJK JP")[明朝体] ("Song" or "Min")
  - #text(font: "Z003")[Script/Handwritten]: #text(font: "LXGW WenKai")[楷体]/#text(font: "Iansui")[楷體] ("Kai")

  _Source Han Sans/Serif CJK_#footnote[Also called Noto Sans/Serif CJK] are the most popular open source CJK fonts, and they provide all regional variants.
][
  #image("imgs/npt/source_han_variants.png", width: 350pt)
]

== The unfortunate reality

- Most fonts only support one language variant
#pause
- Most systems do not have fonts for all the different variants installed
#pause
- Most websites either:
  - Does not specify font (and use the system default):
  ```css
  font-family: sans-serif;
  ```
  - Or use extensive fallbacks:
  ```css
  font-family: "PingFang SC","Heiti SC","Microsoft Yahei",simsun,sans-serif;
  ```
#pause

As a result, using software or browsing websites in a different CJK language variant is often broken or ugly (or both).

= Challenges

#focus-slide[
  But, why???
]

== There are just so many characters

- The latest Unicode standard (18.0) has *101,997* CJK characters.
- And we have multiple glyphs per character (due to Han unification), so the glyph number is much larger.
- Fortunately most of them is not really used. Source Han Serif CJK contains *65,535* glyphs, which is a small subset.
- Designing and building a font for so many glyphs is a lot of work.
#pause
#v(1em)
Also,
- The file size for all region variants of Source Han Serif CJK is *over 100MB*.
- Imagine bundling it in your website `(=_=)`

== Different languages require different design choices

Blindly transfering a font design to a different CJK language usually will not result in a good looking font.

#figure(
  image("imgs/npt/mincho_compare1.jpg", width: 550pt),
  caption: [
    Example: Well designed Chinese and Japanese Serif fonts
  ],
  numbering: none
)

== Case study: Serif fonts in Chinese and Japanese

#slide[
  #figure(
    image("imgs/npt/mincho_compare2.jpg", width: 550pt),
    caption: [
      Lines in Japanese fonts are usually thinner and softer
    ],
    numbering: none
  )
]
#slide[
  #figure(
    image("imgs/npt/mincho_compare4.jpg", width: 600pt),
    caption: [
      In Chinese fonts, the visual shapes of characters are more "square".

      In Japanese fonts the shapes are more freeform.
    ],
    numbering: none
  )
]
#slide[
  This softer, more flexible character design fits better in Japanese text, when mixed with _Kana_.

  #figure(
    image("imgs/npt/mincho_compare3.jpg", width: 600pt),
    caption: [
    ],
    numbering: none
  )

  But when using the same style in Chinese text, it will appear messy and hard to read.
]

= End

#focus-slide[
  This topic goes very deep, but that's all I have.

  Hope you enjoyed my infodump on this rabbit hole :)
]
